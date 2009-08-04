def main():
    while True:
        pullMetadata()
        job = getAssignedJob()
        if job:
            pullData(job.dataRepository)
            setStatusToRunning(job)
            runJob(job)
            setStatusToFinished(job)
        pushMetadata()

def pullMetadata():
    """pull ecidata.git

    load and return project representation."""

def getAssignedJob():
    """check if any jobs have been assigned to this slave and return them if
    they have."""

def setStatusToRunning():
    """update our status in the metadata and push"""

def setStatusToFinished():
    """update our status in the metadata and push"""

def runJob(job):
    """run job, saving stdout/stderr/exticode to files

    might want to put on a bg thread so we can heartbeat our status."""

def pullData(repo):
    """pull the data for the given source data repository at the given
    changelist"""


if __name__ == "__main__": main()
