








	##########################
	##BUILD.SLURM.SUBMISSION##
	##########################
########################################################################################################################
build.slurm.submission <- function(
    scheduler.options = " --ntasks=1 -t 3-00:00:00 ",
    dependencies = NULL,
    job.name,
    log.file,
    job.cmd
) {
    cat("Constructing slurm submission statement.\n")
    sub.cmd <- paste("sbatch",
                     " ", scheduler.options, " ",
                     " --job-name ", job.name, " ",
                     " -o ", log.file,
                     sep="")

    if (!is.null(dependencies)) {
        sub.cmd <- paste(sub.cmd, 
                         " --depend=afterok:", paste(dependencies, collapse=":"), " ", 
                         sep="")
    }

    sub.cmd <- paste(sub.cmd, 
                     " --wrap='", job.cmd, "'",
                     sep="")

    return(sub.cmd)
}
##end BUILD.SLURM.SUBMISSION
########################################################################################################################


	################
	##GET.SLURM.ID##
	################
#
#Extract the scheduler Job ID from the return message
#
########################################################################################################################
get.slurm.id <- function(
			X
			)
{

ret <- unlist(strsplit(X, split=" "))[4]

return(ret)
}##end GET.SLURM.ID
########################################################################################################################



	######################
	##CHECK.SLURM.FOR.ID##
	######################
#
#how do we check the queue for a particular job id?
#
########################################################################################################################
check.slurm.for.id <- function(ID) {
    cmd <- paste("squeue -h -j ", ID, sep="")
    S <- suppressWarnings(system(cmd, intern=TRUE))
    if (length(S) > 0) {
        return(S)
    } else {
        return(NA)
    }
}

##end CHECK.SLURM.FOR.ID
########################################################################################################################


build.scheduler.submission <- build.slurm.submission
get.scheduler.id <- get.slurm.id
check.queue.for.id <- check.slurm.for.id
DEFAULT.SCHEDULER.OPTIONS <- paste(
					" --ntasks=1 ",
					" -t 1-00:00:00 ",	##set a walltime of 1 day.
					" --cpus-per-task=8 ",
					sep="")
THREADS.REGEXP <- "--cpus-per-task="
