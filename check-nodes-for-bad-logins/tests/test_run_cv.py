from unittest import TestCase
import check_nodes.run_cv as cv


class TestCallCvExec(TestCase):
    def setUp(self):
        # Create a 'simulated one' since we can't run cv-exec here
        self.call_cv = cv.CallCvExec(True)

    def test_get_output(self):
        string_output = ""
        with open("example.json", "r") as f:
            string_output = f.readlines()
        self.assertEqual(self.call_cv.get_output(), string_output)