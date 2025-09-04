from io import StringIO
import json

class ClusterLastb():
    # List of nodes
    nodes = {}
    bad_logins = []

    def __init__(self, json_lump):
        # We want to remove extra btmp line
        tmp_data = json.loads(json_lump)
        for node in tmp_data.keys():
            try:
                self.nodes[node] = self._remove_extra_btmp_line_from_node(tmp_data[node])
            except:
                # skip this node, we had an error
                pass
        #print(self.nodes)
        self.bad_logins = self._find_bad_logins()

    def _find_bad_logins(self):
        bad_logins = []
        for name in self.nodes:
            node = self.nodes[name]
            if len(node["stdout"]) > 0:
                bad_logins.append({"node": name, "bad_logins": node["stdout"]})

        return bad_logins

    def _remove_extra_btmp_line_from_node(self, node):
        # First check exit code, if it didn't complete correctly, ignore
        # We actually need to check if length of errors list is longer than 0
        if len(node["errors"]) > 0:
            raise RuntimeError
        else:
            # we can try to remove btmp string because the command succeeded
            node["stdout"] = [x for x in node["stdout"] if 'btmp begins' not in x]
            node["stdout"] = list(filter(None, node["stdout"]))
            return node

    def pretty_print_bad_logins(self):
        output = StringIO(initial_value='', newline='\n')
        print("Bad Logins", file=output)
        print("", file=output)
        for bad_login in self._find_bad_logins():
            print("\t" + bad_login["node"] + ":", file=output)
            for b_l in bad_login["bad_logins"]:
                print("\t" + "\t" + b_l, file=output)

        return output.getvalue()
