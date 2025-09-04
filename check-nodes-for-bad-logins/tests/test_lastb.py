from unittest import TestCase
import check_nodes.lastb
import json

class TestClusterLastb(TestCase):
    def setUp(self):
        self.test_string = '{"gpu001": {"stdout": ["", "btmp begins Mon Sep  1 03:19:01 2025"], "stderr": [], "exit_code": 0, "errors": []}, "gpu002": {"stdout": ["", "btmp begins Mon Sep  1 03:15:01 2025"], "stderr": [], "exit_code": 0, "errors": []}, "gpu003": {"stdout": ["bill.con ssh:notty    10.1.1.254       Wed Sep  3 16:38 - 16:38  (00:00)", "", "btmp begins Wed Sep  3 16:38:42 2025"], "stderr": [], "exit_code": 0, "errors": []}, "node093": {"stdout": [], "stderr": [], "exit_code": 0, "errors": ["Failed to connect to node093: timed out"]}, "viz001": {"stdout": ["", "btmp begins Mon Sep  1 03:15:01 2025"], "stderr": [], "exit_code": 0, "errors": []}}'
        self.lastb = check_nodes.lastb.ClusterLastb(self.test_string)

    def test__init(self):
        lastb = check_nodes.lastb.ClusterLastb(self.test_string)
        # we're dumping bad node node093, so we should have 4 total
        self.assertEqual(len(lastb.nodes), 4)
        # stdout should be an empty list for gpu001
        self.assertEqual(lastb.nodes["gpu001"]["stdout"],[])
        # stdout should be length one for gpu003
        self.assertEqual(len(lastb.nodes["gpu003"]["stdout"]),1)
        # First item in stdout for gpu003 should be my login info
        self.assertEqual(lastb.nodes["gpu003"]["stdout"][0], "bill.con ssh:notty    10.1.1.254       Wed Sep  3 16:38 - 16:38  (00:00)")

    def test__remove_extra_btmp_line(self):
        test_string_ok = '{"stdout": ["", "btmp begins Mon Sep  1 03:19:01 2025"], "errors": []}'
        test_string_ok_result = '{"stdout": [], "errors": []}'
        test_string_not_ok = '{"stdout": ["", "btmp begins Mon Sep  1 03:19:01 2025"], "errors": ["error"]}'
        self.assertEqual(self.lastb._remove_extra_btmp_line_from_node(json.loads(test_string_ok)),
                         json.loads(test_string_ok_result))
        with self.assertRaises(RuntimeError):
            self.lastb._remove_extra_btmp_line_from_node(json.loads(test_string_not_ok))
        #print(self.lastb._remove_extra_btmp_line_from_node(json.loads(self.test_string)["gpu001"]))

    def test__find_bad_logins(self):
        result = self.lastb._find_bad_logins()
        # From the test_string there is 1 result
        self.assertEqual(len(result), 1)
        # with this value
        value = "bill.con ssh:notty    10.1.1.254       Wed Sep  3 16:38 - 16:38  (00:00)"
        self.assertEqual(result[0]["bad_logins"][0], value)

    def test_pretty_print_bad_logins(self):
        expected_output = \
"""Bad Logins

	gpu003:
		bill.con ssh:notty    10.1.1.254       Wed Sep  3 16:38 - 16:38  (00:00)
"""
        result = self.lastb.pretty_print_bad_logins()

        self.assertEqual(result, expected_output)