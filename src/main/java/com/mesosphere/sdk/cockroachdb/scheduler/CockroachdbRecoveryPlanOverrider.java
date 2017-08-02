package com.mesosphere.sdk.cockroachdb.scheduler;

import com.mesosphere.sdk.scheduler.plan.*;
import com.mesosphere.sdk.scheduler.plan.strategy.ParallelStrategy;
import com.mesosphere.sdk.scheduler.recovery.DefaultRecoveryStep;
import com.mesosphere.sdk.scheduler.recovery.RecoveryPlanOverrider;
import com.mesosphere.sdk.scheduler.recovery.RecoveryType;
import com.mesosphere.sdk.scheduler.recovery.constrain.UnconstrainedLaunchConstrainer;
import com.mesosphere.sdk.specification.*;
import com.mesosphere.sdk.state.StateStore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/**
 * The CockroachdbRecoveryPlanManager handles failure scenarios unique to Cockroachdb. 
 * It falls back to the default recovery
 * behavior when appropriate.
 */
public class CockroachdbRecoveryPlanOverrider implements RecoveryPlanOverrider {
    protected final Logger logger = LoggerFactory.getLogger(getClass());
    private static final String RECOVERY_PHASE_NAME = "permanent-node-failure-recovery";
    private final StateStore stateStore;
    private final Plan replaceNodePlan;

    public CockroachdbRecoveryPlanOverrider(
            StateStore stateStore,
            Plan replaceNodePlan) {
            this.stateStore = stateStore;
            this.replaceNodePlan = replaceNodePlan;
            }

    @Override
    public Optional<Phase> override(PodInstanceRequirement stoppedPod) {
        if (stoppedPod.getPodInstance().getIndex() != 0) {
            logger.info("No overrides necessary. Pod is not cockroachdb-0.");
            return Optional.empty();
        }

        if (stoppedPod.getRecoveryType() != RecoveryType.PERMANENT) {
            logger.info("No overrides necessary, RecoveryType is {}.", stoppedPod.getRecoveryType());
            return Optional.empty();
        }

        stateStore.clearTask("cockroachdb-0-node-init");

        logger.info("Returning replace plan for cockroachdb-0");
        return Optional.ofNullable(getNodeRecoveryPhase(replaceNodePlan));
    }

    private Phase getNodeRecoveryPhase(Plan inputPlan) {
        Phase inputPhase = inputPlan.getChildren().get(0);
        Step inputJoinStep = inputPhase.getChildren().get(0);


        PodInstance joinPodInstance = inputJoinStep.start().get().getPodInstance();
        PodSpec joinPodSpec = joinPodInstance.getPod();
        TaskSpec joinTaskSpec = joinPodSpec.getTasks().stream()
                .filter(t -> t.getName().equals("node-init")).findFirst().get();

        // Dig into the node-init to get the command revised
        CommandSpec command = joinTaskSpec.getCommand().get();
        DefaultCommandSpec.Builder builder = DefaultCommandSpec.newBuilder(command);
        builder.value(command.getValue().replace("start.sh", "join.sh"));

        // Form a new join task using the revised command
        TaskSpec newTaskSpec = DefaultTaskSpec.newBuilder(joinTaskSpec).commandSpec(builder.build()).build();
        PodSpec newJoinPodSpec = DefaultPodSpec.newBuilder(joinPodSpec)
                .tasks(Arrays.asList(newTaskSpec)).build();
        PodInstance newJoinPodInstance = new DefaultPodInstance(newJoinPodSpec, 0);

        // Put all the task into one step
        Collection joinCollect = inputJoinStep.start().get().getTasksToLaunch();
        Collection<String> all = new ArrayList<>();
        all.addAll(joinCollect);
        PodInstanceRequirement joinPodInstanceRequirement =
                PodInstanceRequirement.newBuilder(
                        newJoinPodInstance, all)
                        .recoveryType(RecoveryType.PERMANENT)
                        .build();

        Step joinStep = new DefaultRecoveryStep(
                inputJoinStep.getName(),
                Status.PENDING,
                joinPodInstanceRequirement,
                new UnconstrainedLaunchConstrainer(),
                stateStore);

        Phase phase = new DefaultPhase(
                RECOVERY_PHASE_NAME,
                Arrays.asList(joinStep),
                new ParallelStrategy<>(),
                Collections.emptyList());

        return phase;
      }
}
