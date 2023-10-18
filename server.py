import os
from pyngrok import ngrok
import smtplib
from email.message import EmailMessage
# mkdir hdd
# chmod +x hdd
os.system("sudo mount /dev/sda hdd/")
os.system("sudo filebrowser -r hdd/ &")
# os.system("ngrok http 8080")

ngrok_tunnel = ngrok.connect(8080, "http")

forwarded_link = ngrok_tunnel.public_url
print("Forwarded Link:", forwarded_link)
os.system(f"echo {forwarded_link} | xclip -sel clip")
# pywhatkit.sendwhatmsg_instantly("+919717166477",forwarded_link,6)

smtp_server = "smtp.gmail.com"
smtp_port = 25

# Create an SMTP connection
smtp_connection = smtplib.SMTP(smtp_server, smtp_port)
smtp_connection.starttls()  # Enable TLS encryption

email_address = 'adityagautam2705@gmail.com'
email_password = 'bsegkqlxnwcwpjkj'

smtp_connection.login(email_address, email_password)

message = EmailMessage()
message.set_content(forwarded_link)
message['Subject'] = "Automated mail to send home server link to myself when I am not at home"
message['From'] = email_address
message['To'] = "adityascottish27@gmail.com"

smtp_connection.send_message(message)
smtp_connection.quit()
# Keep the script running (you might need to interrupt the script to stop)
try:
    input("Press Enter to stop...")
finally:
    # Close the tunnel when done
    ngrok.kill()
