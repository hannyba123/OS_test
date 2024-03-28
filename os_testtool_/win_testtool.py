#!/usr/bin/python3
import paramiko,os,time,hashlib,datetime,logging,socket,re,subprocess

#os_ip_ad = '10.64.10.126'
#username = 'root'
#passwd = '1'
#bmc_ip_ad = '10.64.10.69'
#bmc_username = 'Administrator'
#bmc_passwd = 'qwer1234$'
#loop = 20
PORT = 22
TIMES =1
dict_ = {
'cpu':'lscpu | grep "CPU(s)"',#'mem':'dmidecode -t memory node size |egrep "GB|Dimm"|egrep -v "No Module Installed|None"',
#'mem':'dmidecode -t memory node size |egrep "GB|Dimm"|egrep -v "No Module Installed|None"',
#'mem':'dmidecode -t memory node size|grep -A 3 "GB"|grep -viE "Volatile|Cache|Logical|Set|Factor"',
'mem':'dmidecode -t memory node size|grep -A 3 "GB"',
#'disk':'fdisk -l|egrep -i "dev"|egrep -v "loop|Disk"',
#'disk':'df -H|sort|grep -Ev "tmpfs|mapper"',
'disk':'lsblk -t',
'nic':'ip address show |grep "BROADCAST"|grep -v "virbr"|awk -F: "{print \$2 \$3}"|sort -n'}
list_ = ['cpu','mem','disk','nic']

log_fail_keywords_ = ['error']

class python_log(object):
        def __init__(self):
                self.logger = logging.getLogger(__name__)
                self.logger.setLevel(level = logging.INFO)
                now_time = datetime.datetime.now().strftime('%Y%m%d_%Hh%Mm%Ss')
                log_name = f'{now_time}.log'
                formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

                handler = logging.FileHandler(log_name, mode='w')
                handler.setLevel(logging.INFO)
                handler.setFormatter(formatter)

                console = logging.StreamHandler()
                console.setLevel(logging.INFO)
                console.setFormatter(formatter)

                self.logger.addHandler(handler)
                self.logger.addHandler(console)

class SshConnect:
        __slots__ = 'ip','username','passwd','port','ssh'
        def __init__(self,ip,port):
                self.ip = ip
#                self.username = username
#                self.passwd = passwd
                self.port = port
        @staticmethod
        def connect(self):
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                ssh.connect(self.ip,self.port,self.username,self.passwd)
                logger.info('Succeed connect to OS')
                return ssh
        def check_link(self):
#                s = socket.socket()
#                check = s.connect_ex((self.ip, self.port))
#                if check == 0:
#                        logger.info('Succeed catched SIGN to SUT')
#                        return True
#                except socket.error as e:
#                else:
#                        logger.warn('Failed connect to SUT')
#                        return False
                 execmd = f'ping -c 3 {self.ip}'
                 output = os.system(execmd)
#                 logger.info(output)
                 if output == 0:
                        logger.info('Succeed catched SIGN to SUT')
                        return True
                 else:
                        logger.warn('Failed connect to SUT')
                        return False


#connect function
def connect_sut():
        args = True
        ssh = SshConnect(os_ip_ad,PORT)
        while args:
                try:
                        time.sleep(0.5)
                        check = ssh.check_link()
                        if check == True:
                              args = False
                              break
                        time.sleep(30)
                except TimeoutError as e:
                        raise
       #_ssh=ssh.connect(ssh)
       # return _ssh

class compare(object):
	def __init__(self,path0='',path1=''):
		self.source = open(path0 , 'rb')
		self.target = open(path1 , 'rb')
	def getMD5_diff(self):
		file_source = self.source.read()
		self.source.close()
		file_target = self.target.read()
		self.target.close()
		source_md5 = hashlib.md5(file_source).hexdigest()
		target_md5 = hashlib.md5(file_target).hexdigest()
		if source_md5 == target_md5:
			return True
		else:
			return False

def execute(which):   
        times = start_loop        
        sel_clear()
        while True:
                logger.info('*'*50+f' {times} '+'*'*50)
                if times != 1:
                        logger.info (f'waiting OS booting........................')
                ssh = connect_sut()                
#                for i in list_:
#                        check = hardware_check(ssh,dict_[i],i,times)
#                        if check is True:
#                                  logger.info(f'{i}--------------------------------------------------\033[0;32;40m[working]\033[0m')
#                        if check is False:
#                                  logger.warn(f'{i}--------------------------------------------------\033[0;31;40m[no work]\033[0m')
#                logger.info ('nic speed as below:') 
#                nic_speed_check(ssh)
#                logger.info ('pci Speed and Width as below:')
#                pci_speed_check(ssh)
#                dmesg_check(ssh,times)
#                sel_check(ssh,times)
#                time.sleep(1)
#                sel_clear(ssh)
#                restart(ssh,times,which)
#                ssh.close()
#                time.sleep(5)
#                if rematch(times) is False:
#                        logger.info ('The match result is \033[0;31;40m[failed]\033[0m')
#                        break
                if times == loop:
                        logger.info('*'*100)
                        logger.warn('The match result is \033[0;32;40m[sucessed]\033[0m\nTest finished')
                        break
                if which == 'reboot' or which == 'powercycle':
                        restart(times,which)
                if which == 'ac':
                        logger.info ('OS to ac')
                        ac_oloff(ac_ip,ac_name,ac_passwd,ac_outlet)
                        time.sleep(10)
                        ac_olon(ac_ip,ac_name,ac_passwd,ac_outlet)
#                ssh.close()
                time.sleep(5)
                times = times+1


def hardware_check(ssh_,command,logname,times):
        execmd = command
        stdin,stdout,stderr = ssh_.exec_command (execmd)
        if times == 1:
            f = open(f'{logname}0.log',mode = 'w',encoding = 'utf-8')
        else:
            f = open(f'{logname}1.log',mode = 'w',encoding = 'utf-8')
        std = stdout.read().decode('utf-8')
        if std == "":
                return False
        else:
                prt = f'{logname}_check_output:' + '\n' + std
                f.write(prt)
                f.close()
                logger.info(prt)
                return True

def nic_speed_check(ssh_):
	#get nic_name(2 col)
        execmd = 'ip address show |grep "BROADCAST" |grep -v "virbr"|awk -F: "{ print \$2}"'
        stdin,stdout,stderr = ssh_.exec_command (execmd)
        nic_name = stdout.readlines()
        for n in nic_name:
	    #verity ethtool install
            nic_name = str(f'{n}').strip('\n')
            execmd = 'ethtool '+nic_name+' | egrep -i "settings|Speed"'
            stdin,stdout,stderr = ssh_.exec_command (execmd)
            std = stdout.read().decode('utf-8').replace('\n\t','')
            logger.info ('nic speed : '+std)

def pci_speed_check(ssh_):
        execmd = 'dmidecode -t 9 | grep "Bus Address" |sed "s,Bus Address:,,g"'
        stdin,stdout,stderr = ssh_.exec_command (execmd)
        pci_name = stdout.readlines()
        for n in pci_name:
            bus_slot = str(f'{n}').strip('\n').replace('\t','')
            execmd = 'lspci -s '+bus_slot+" -vvv | grep -i LnkSta |grep -v LnkSta2|awk -F, '{print $1 $2}'"
            stdin,stdout,stderr = ssh_.exec_command (execmd)
            std = stdout.read().decode('utf-8').replace('\t','')
            logger.info (f'{bus_slot} '+std)

def dmesg_check(ssh_,times_):
	execmd = 'dmesg -T |egrep -i "error|failed|warning|bug|respond|wrong|pending|call trace"'
	stdin,stdout,stderr = ssh_.exec_command(execmd)
	if times_ == 1:
		with open('dmesg0.log',mode = 'w',encoding = 'utf-8') as f:
			std = stdout.read().decode('utf-8')
			f.write('*'*50+str(times_)+'*'*50+'\n')
			f.write('divece_message_output:\n'+std)
#			f.write('*'*50+str(times_)+'*'*50+'\n')
			for word in log_fail_keywords_:
				if re.findall(word,std,re.I):
					logger.warn('Dmesg log has error')
					break
	else:
		with open('dmesg0.log',mode = 'a+',encoding = 'utf-8') as f:
			std = stdout.read().decode('utf-8')
			f.write('*'*50+str(times_)+'*'*50+'\n')
			f.write('divece_message_output:\n'+std)
#			f.write('*'*50+str(times_)+'*'*50+'\n')
			for word in log_fail_keywords_:
				if re.findall(word,std,re.I):
                                	logger.warn('Dmesg log has error')
                                	break
	f.close()
	logger.info('dmesg log had collected')

def sel_check(ssh_,times_):
        execmd = 'ipmitool sel elist'
        stdin,stdout,stderr = ssh_.exec_command(execmd)
        with open('sel.log',mode = 'a+',encoding = 'utf-8') as f:
                std = stdout.read().decode('utf-8')
                f.write('*'*50+str(times_)+'*'*50+'\n')
                f.write('sel_message_output:\n'+std)
#                f.write('*'*50+str(times_)+'*'*50+'\n')
                for word in log_fail_keywords_:
                        if re.findall(word,std,re.I):
                                logger.warn('SEL has error')
                                break
        f.close()
        logger.info('sel log had collected')

def sel_clear():
        execmd = f'ipmitool -I lanplus -H {bmc_ip_ad} -U {bmc_name} -P {bmc_passwd}  sel clear'
        output = os.popen(execmd)
        logger.info(output.read())

def restart(times,which):
        if which == 'reboot':
                execmd = 'date && reboot'
                stdin,stdout,stderr = ssh_.exec_command (execmd)
                with open(f'{which}.log', mode = 'a+',encoding='utf-8') as f:
                         f.write(stdout.read().decode('utf-8'))
                         f.write(f'The {which} time is {times}\n')
                ssh_.close()
        if which == 'powercycle':
                execmd = f'ipmitool -I lanplus -H {bmc_ip_ad} -U {bmc_name} -P {bmc_passwd} chassis power cycle'
                output = os.popen(execmd)
                logger.info(output.read())
        logger.info(f'OS to {which}')

def ac_oloff(ac_ip,ac_name,ac_passwd,ac_outlet):
        sub1 = subprocess.Popen(["./apc.sh",ac_ip,ac_name,ac_passwd,'oloff',ac_outlet],stdout=subprocess.PIPE)
        out=sub1.stdout.read().decode('utf-8')
        print (out)

def ac_olon(ac_ip,ac_name,ac_passwd,ac_outlet):
        sub1 = subprocess.Popen(["./apc.sh",ac_ip,ac_name,ac_passwd,'olon',ac_outlet],stdout=subprocess.PIPE)
        out=sub1.stdout.read().decode('utf-8')
        print (out)


def rematch(times):
        if times == 1:
            pass
        else:
            logger.info('Checking with last device infomation:')
            for i in list_:
                 if compare(f'{i}0.log',f'{i}1.log').getMD5_diff() is True:
                        logger.info(f'{i} infomation is \033[0;32;40m[matching]\033[0m')
                 else:
                        logger.warn(f'{i} infomation is \033[0;31;40m[mismatching]\033[0m')
                        return False
#get log name
def loglist():
	loglist_ = os.listdir(".")
	loglist_ = list(filter(lambda k:k.find(".log") >= 0,loglist_))
	return loglist_

def move(which):
    if  os.path.exists("log"):
        os.rename('log','old_log'+'_'+'{}'.format(datetime.datetime.now()))
        os.makedirs("log")
    else:
        os.makedirs("log")
    time.sleep(1)
    dir_ = loglist()
    for logfile in dir_:
        logfile = '{}'.format(logfile)
        os.rename(logfile , 'log'+'/'+'{}'.format(logfile))
    os.rename('log',f'{which}_log'+'_'+'{}'.format(datetime.datetime.now().strftime('%Y%m%d_%Hh%Mm%Ss')))


if __name__ == "__main__":
    sure = input('Are you sure SUT install ethtool and ipmitool? y or n\n').lower()
    if sure == 'y':
#         global logger
         logger = python_log().logger
         try:
                 os_ip_ad = str(input('os_ip_ad:'))
#                 username = str(input('username:'))
#                 passwd = str(input('passwd:'))                 
                 loop = int(input('loop:'))
                 start_loop = int(input('start_loop:'))
         except Exception as e:
                 logger.warn('input error')

         which = input('Which case do you want to run?reboot or powercycle or ac\n').lower()
         if which == 'reboot':
                 execute(which)
                 move(which)
         elif which == 'powercycle':
                 bmc_ip_ad = str(input('BMC IP:'))
                 bmc_name = str(input('BMC_USERNAME:'))
                 bmc_passwd = str(input('BMC_PASSWD:'))
                 execute(which)
                 move(which)
         elif which == 'ac':
                 ac_ip = str(input('APC IP:'))
                 ac_name = str(input('APC username:'))
                 ac_passwd = str(input('APC password:'))
                 ac_outlet = str(input('APC outlet(ex 1 2):'))
                 execute(which)
                 move(which)
         else:
                 print('input error,please restart')
