


for x in 2021-{00..08}; do ls -lah /home/fringe/.history/2020-0$x/*; done

for user in cookj fringe mariusz.pajecki acesshubid; do ls -lah  /home/$user/.history/; done && for user in cookj fringe mariusz.pajeckiac accesshubid; do ls -lah  /home/$user/; done 

for x in {07..12}; do rm -f /home/cookj/.history/2020-$x/cookj_*; done &&  ls -lah
  /home/cookj/.history/ && df -Th /home

for user in fringe cookj mariusz.pajecki accesshubid; do ls -lah  /home/$user/.history/; done && for X in  fringe cookj mariusz.pajecki accesshubid; do ls -lah  /home/$X/; done 



/home/accesshubid/.history/

for DIR in home root; do df -/$DIR/;done && for user in cookj root; do du -sh /home/$user/* 

du -sh /home/

for user in fringe mariusz.pajecki acesshubid; do ls -lah  /home/$user/.history/; done && for user in fringe mariusz.pajecki accesshubid; do ls -lah  /home/$user/; done 


https://tower.fringe.ibm.com/#/jobs/playbook/164696/host-event/36795682/json?job_search=page_size:20;order_by:-finished;not__launch_type:sync


for x in {02..04}; do rm -f /home/fringe/.history/2021-$x/*.log.auth;done'




This is the correct way:

iptables -A INPUT -p tcp --match multiport --dports 1024:3000 -j ACCEPT