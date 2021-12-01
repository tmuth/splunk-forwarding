FROM splunk/splunk

RUN sudo microdnf install nc findutils
RUN pip install faker
RUN pip install faker_vehicle

COPY bashrc-custom.sh /etc/profile.d/