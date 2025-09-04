#!/bin/sh
"exec" "`dirname $0`/.venv/bin/python" "$0" "$@"

from check_nodes import CallCvExec, ClusterLastb
from email_info import EmailBadLogins

email_addresses_to_send_too = ["bill.conn@usd.edu"]

def main():
    cv = CallCvExec()
    lastb = ClusterLastb(cv.get_output())

    if len(lastb.bad_logins) > 0:
        # We've got bad logins, we should email_info Bill
        email_logins = EmailBadLogins(email_addresses_to_send_too, "root@lawrence-head.usd.edu",
                                      "Bad ssh logins on Lawrence", lastb.pretty_print_bad_logins())
        email_logins.send_emails()


if __name__ == '__main__':
    main()