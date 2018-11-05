import sys, os, textwrap, datetime
import subprocess as sb
from time import sleep
from model import models
from util import shell
from net import iptables


class CmdInvoker:

    def __init__(self):
        self.cmd_stack = []


    def add_cmd(self, cmd):
        self.cmd_stack.append(cmd)


    def exec(self):
        try:
            for cmd in self.cmd_stack:
                cmd.exec()
        except sb.CalledProcessError as e:
                print(e)
                print('外部プログラムの実行に失敗しました', file=sys.stderr)


class CmdFactory:

    def create(self, cmd_args):
        act = cmd_args.act
        inv = CmdInvoker()

        if(act == 'init'):
            inv.add_cmd(InitCmd(cmd_args))
        elif(act == 'start'):
            inv.add_cmd(StartCmd(cmd_args))
        elif(act == 'stop'):
            inv.add_cmd(StopCmd(cmd_args))
        elif(act == 'delete'):
            inv.add_cmd(DeleteCmd(cmd_args))
        elif(act == 'launch'):
            inv.add_cmd(LaunchCmd(cmd_args))
        elif(act == 'gen_sshkey'):
            inv.add_cmd(GenSshKey(cmd_args))
        elif(act == 'ssh'):
            inv.add_cmd(SshCmd(cmd_args))
        elif(act == 'toimg'):
            inv.add_cmd(StopCmd(cmd_args))
            inv.add_cmd(ToimgCmd(cmd_args))
            inv.add_cmd(StartCmd(cmd_args))
        elif(act == 'add_pfd'):
            inv.add_cmd(AddPortforwardCmd(cmd_args))
        elif(act == 'remove_pfd'):
            inv.add_cmd(RemovePortforwardCmd(cmd_args))
        elif(act == 'take_snap'):
            inv.add_cmd(TakeSnapshotCmd(cmd_args))
        elif(act == 'del_snap'):
            inv.add_cmd(DeleteSnapshotCmd(cmd_args))

        return inv


class BaseCmd:

    def __init__(self, cmd_args):
        self.cmd_args = cmd_args
        self.ct_path = cmd_args.ct_path
        self.se = shell.ShellExec()
        self.ct = self.load_ct(f"{self.ct_path}/.conf/ct.yml")


    def load_ct(self, ct_yml_path):
        if(os.path.exists(ct_yml_path)):
            return models.Container(ct_yml_path)
        else:
            return None


    def exec(self):
        pass


class InitCmd(BaseCmd):

    def exec(self):

       if(self.cmd_args.ct_name):
           ct_name = self.cmd_args.ct_name
       else:
           ct_name = os.path.basename(self.ct_path)

       models.ContainerFactory.create(ct_name, self.cmd_args.img, f"{self.ct_path}")


class StartCmd(BaseCmd):
    def exec(self):
        self.se.sh(f"lxc start {self.ct.container['name']}")


class StopCmd(BaseCmd):
    def exec(self):
        self.se.sh(f"lxc stop {self.ct.container['name']}")


class DeleteCmd(BaseCmd):

    def exec(self):
        self.se.sh(f"lxc delete {self.ct.container['name']}")
        self.ct.destroy()


class LaunchCmd(BaseCmd):

    def exec(self):
        self.se.sh(f"lxc start {self.ct.container['name']}")
        sleep(7)
        self.se.sh(f"cd {self.ct_path} && ./setup.sh {self.ct.container['name']}")


class SshCmd(BaseCmd):

    def exec(self):
        ip = self.ct.main_ip()
        os.system(f"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i .conf/private_key maintain@{ip}")


class ToimgCmd(BaseCmd):

    def exec(self):
        self.se.sh(f"lxc publish {self.ct.container['name']} --alias {self.ct.container['name']}")


class GenSshKey(BaseCmd):

    def exec(self):
        ct_name = self.ct.container['name']
        user_name = self.cmd_args.ssh_user

        scripts_var = {'ct_path': self.ct_path,
                'ct_name': self.ct.container['name'],
                'user_name': self.cmd_args.ssh_user}

        scripts = textwrap.dedent("""
            cd {ct_path}
            rm -f .conf/private_key
            ssh-keygen -f .conf/private_key -t rsa -b 4096 -C "{user_name} key pair" -q -N ""
            lxc file push .conf/private_key.pub {ct_name}/home/{user_name}/.ssh/authorized_keys

            lxc exec {ct_name} -- bash -lc '\
                    chmod 600 /home/{user_name}/.ssh/authorized_keys; \
                    chown {user_name}:{user_name} /home/{user_name}/.ssh/authorized_keys \
                    '
        """.format(**scripts_var)).strip()
        self.se.sh(scripts)


class AddPortforwardCmd(BaseCmd):

    def exec(self):
        portforward = self.cmd_args.portforward

        pd_array = portforward.split(':')
        proto,sport,dport = pd_array[0],pd_array[1],pd_array[2]

        pfd = iptables.Portforward(self.ct)
        pfd.add_portfoward(proto, sport,dport)

        pfd_list = self.ct.lxtdata['portforward']
        pfd_list.append(portforward)
        self.ct.lxtdata['portforward'] = pfd_list
        self.ct.save()


class RemovePortforwardCmd(BaseCmd):

    def exec(self):
        portforward = self.cmd_args.portforward

        pd_array = portforward.split(':')
        proto,sport,dport = pd_array[0],pd_array[1],pd_array[2]

        pfd = iptables.Portforward(self.ct)
        pfd.remove_portfoward(proto, sport,dport)

        pfd_list = self.ct.lxtdata['portforward']
        pfd_list.remove(portforward)
        self.ct.lxtdata['portforward'] = pfd_list
        self.ct.save()


class TakeSnapshotCmd(BaseCmd):

    def exec(self):
        now = datetime.datetime.today()
        snap_name = "snap_" + now.strftime('%Y-%m-%d_%H:%M:%S.%f')
        self.se.sh(f"lxc snapshot {self.ct.container['name']} {snap_name}")

