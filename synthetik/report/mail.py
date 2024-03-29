import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email.Utils import COMMASPACE, formatdate
from email import Encoders
import os
import socket


def sendMail(to, fro, subject, text, server="localhost"):
	assert type(to)==list

	sendMailWithFiles(to, fro, subject, text, [], server="localhost")

def sendMailWithFiles(to, fro, subject, text, files=[],server="localhost"):
    assert type(to)==list
    assert type(files)==list

    # first we need to make sure we are on the head node, or we can't send mail
    if socket.gethostname() != "head.cluster":
        raise ValueError("Hostname is socket.gethostname() and not head.cluster. Can't send email")

    msg = MIMEMultipart()
    msg['From'] = fro
    msg['To'] = COMMASPACE.join(to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    msg.attach( MIMEText(text) )

    for file in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(file,"rb").read() )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"'
                       % os.path.basename(file))
        msg.attach(part)

    smtp = smtplib.SMTP(server)
    smtp.sendmail(fro, to, msg.as_string() )
    smtp.close()

