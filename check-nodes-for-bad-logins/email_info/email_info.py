import datetime
from io import StringIO
import smtplib
from email.message import EmailMessage

class EmailBadLogins:
    recipients = []
    email_from = ""
    subject = ""
    message_body = ""

    def __init__(self, email_to = list, email_from = str, subject = str, main_body = str):
        if len(email_to) < 1:
            raise RuntimeError("Need at least one recipient")
        self.recipients = email_to
        if not email_from:
            self.email_from = "rcg@usd.edu"
        if not subject:
            raise RuntimeError("Need a subject for email")
        self.subject = subject
        if not main_body:
            raise RuntimeError("Need a list of bad logins to email")
        self.message_body = self.__create_email_body(main_body)

    def __create_email_body(self, main_body):
        message_body = StringIO()
        date = datetime.date.today()
        print(f"Here is a list of bad logins for {date}", file=message_body)
        print("", file=message_body)
        print(main_body, file=message_body)

        return message_body.getvalue()

    def _send_mail(self, to, fro, subject, message):
        # mail.sendMail(to, fro, subject, message)
        msg = EmailMessage()
        msg['Subject'] = subject
        msg['From'] = fro
        msg['To'] = to
        msg.set_content(message)

        s = smtplib.SMTP('localhost')
        s.send_message(msg)
        s.quit()

    def send_emails(self):
        self._send_mail(",".join(self.recipients), self.email_from, self.subject, self.message_body)