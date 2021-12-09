FROM splunk/splunk
ARG CACHE_BUST

RUN sudo microdnf install nc findutils xz xz-devel util-linux
RUN sudo pip install --upgrade
RUN sudo pip install faker sh pandas
#RUN pip install faker_vehicle
RUN sudo echo "splunk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Next 2 RUNs are for htop which is optional
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN sudo microdnf install htop ack

COPY bashrc-custom.sh /etc/profile.d/
COPY h.sh /etc/profile.d/
RUN sudo chmod +x /etc/profile.d/*.sh

COPY tail-metrics.sh /home/splunk/
COPY tcp.py /home/splunk/
RUN sudo chmod +x /home/splunk/*; sudo chown splunk:splunk /home/splunk/tcp.py

RUN mkdir /tmp/splunk
COPY splunk /tmp/splunk
#COPY splunk/* /opt/splunk/etc/system/local
RUN sudo ln -s /opt/splunk/etc/system/local ~splunk/.
RUN sudo usermod -a -G splunk ansible
RUN sudo usermod -a -G sudo splunk