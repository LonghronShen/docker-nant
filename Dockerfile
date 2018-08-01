# escape=`

FROM microsoft/windowsservercore:ltsc2016

# Setting up Environment variables
ENV BuildVersion "1.0.0.0"
ENV NantVersion "0.92"
ENV NantPath "C:/Tools/"

# Copy the Nant binaries
ADD nant-${NantVersion}-bin.zip ${NantPath}\nant-${NantVersion}-bin.zip

# Extract Nant tool to NantPath, remove package, and set up the environment path
RUN powershell -Command `
    Expand-Archive %NantPath%\nant-%NantVersion%-bin.zip %NantPath%; `
    Remove-Item %NantPath%\nant-%NantVersion%-bin.zip -Force; `
    Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session` Manager\Environment" -Name PATH -Value (%{'{0};{1}' -f '%NantPath%nant-%NantVersion%/bin',$Env:Path});

# Default to Nant if no other command specified.
CMD ["nant.exe"]