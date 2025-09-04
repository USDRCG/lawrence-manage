import os
import subprocess

class CallCvExec():
    command = ["cv-exec", "-g", "nodes,gpu,himem,viz", "--format=json", "lastb -w --since yesterday"]
    output = ""

    def __init__(self, simulate=False):
        if simulate:
            with open("example.json", "r") as f:
                self.output = f.readlines()
        else:
            # Verify we're root
            if os.geteuid() != 0:
                raise RuntimeError("This should only be run as root")

            p = subprocess.run('ls -l', shell=True, check=True, capture_output=True, encoding='utf-8')

            # Check return code for error
            # Actually, ignore this, if a node reports an error, cv-exec doesn't exit with returncode 0
            #if p.returncode != 0:
            #    raise RuntimeError(f"Error running command: {self.command}")

            # save the output, ignore the stderr
            self.output = p.stdout


    def get_output(self):
        return self.output

