FROM mono:5

ADD nant-0.92-bin.tar.gz /usr/local/

RUN tee /usr/local/bin/nant <<-'EOF'
#!/bin/sh
exec mono /usr/local/nant-0.92/bin/NAnt.exe "$@"
EOF

RUN chmod a+x /usr/local/bin/nant

CMD /usr/local/bin/nant