import os
import time
import vulnerability_scan
import shutil


def vuln_scan_switch():
    user_input = str(input("Would you to scan for vulnerabilities? (y/n): "))
    if user_input == "y":
        print("The computer will scan for vulnerabilities")
        vuln_scan = True
    else:
        print("The computer will not scan for vulnerabilities")
        vuln_scan = False
    return vuln_scan



path = os.getcwd()
os.system("cd " + path)
vuln_scan = vuln_scan_switch()

if os.listdir(os.getcwd()).__contains__("config.txt") == False:
    with open("config.txt", "w") as file:
        file.close()


content = []

    
os.system("clear")
print("Scanning the network")

os.system("ip a")
ip = str(input("Enter the ip address of the network you would like to scan: "))

ip1 = ip.split(".")[0]
ip2 = ip.split(".")[1]
ip3 = ip.split(".")[2]

ip = ip1 + "." + ip2 + "." + ip3 + "."
for i in range(0, 255):
    ip_scan = ip + str(i)
    print("Scanning " + ip_scan)
    os.system("sudo nmap -sS " + ip_scan)


    response = os.popen("sudo nmap -sS " + ip_scan).read()

    if "Host seems down" in response:
        print(ip + " is down \n")
    else:
        os.system("sudo nmap -sS " + ip_scan)
        
        host = os.popen("host " + ip_scan).read().split(" ")[4]
        host = host.split("\n")[0]
        print("The host is: " + host)
        
        
        
        content.append(ip + " | " + host + "\n")
        time.sleep(1)

file_name = time.strftime("%Y-%m-%d_%H-%M-%S") + "_hosts.txt"
os.system("touch /scan_history" + file_name)
with open("scan_history/" + file_name, "w") as file:
    file.close()


with open("config.txt", "r") as file:
    content = file.read()
    file.close()

if content.__contains__("newest scan = "):
    os.system("rm config.txt")
    with open("config.txt", "w") as file:
        file.write("newest scan = scan_history/" + file_name)
        file.close()
else:
    with open("config.txt", "w") as file:
        file.write("newest scan = scan_history/" + file_name)
        file.close()

with open("scan_history/" + file_name, "a") as file:
    for i in range(len(content)):
        file.write(content[i])
    file.close()
print(ip + " is up \n")
print("Scan completed")

if vuln_scan:
    vulnerability_scan.vulnerability_scan(file_name)
