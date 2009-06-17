import yaml
import time

def main():
    while True:
        pullData()
        for proj in data.projects:
            if proj.pendingJobs != None:
                assignJobsToSlaves(proj.pendingChange, proj.pendingJobs)
                continue
            change = getNextChange(proj)
            proj.pendingChange, proj.pendingJobs = assignJobsToSlaves(change, proj.jobs)
        pushData()
        time.sleep(5)


def pullMetadata():
    """pull ecidata.git
    
    load and return project representation"""


def getNextChange(proj):
    """get data for the next change from projects/$proj/changes or None if
    no changes have been commited to the data repo for $proj"""

def assignJobsToSlaves(change, jobs):
    """for all of the jobs that have their dependencies already satisfied,
    assign as many as we can to available slaves.

    return the rest of the jobs along with the change so we can schedule them
    next time around."""

def pushMetadata():
    """write? and push ecidata.git back to main sync location."""


if __name__ == "__main__": main()
