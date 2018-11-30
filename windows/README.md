### Overview
Docker base image with NAnt build tool included. NAnt enables various tasks execution without writing shell commands and uses xml-based configuration,

Current NAnt Build Tool version included: v0.92.

### Usage
* Docker Base Image: nant-windowsservercore-ltsc2016:1.0
* Docker Registry: docker-dev.phibred.com
* Custom Script in Build Step:
    ```cmd
    Nant [-D:<your NAnt argument>=<your build number>]
    ```
* In your solution (*.sln) file, include the xml-based *.build task configuration file. Below is the example of NAnt build configuration:
    ``` xml
    <?xml version="1.0" encoding="utf-8"?>
    <project name="AssemblyInfoHelper" default="extractVersion" basedir=".">
        <target name="extractVersion">
        
            <if test="${not property::exists('BuildNumber')}">
                <property name="BuildNumber" value="${environment::get-variable('BUILD_NUMBER')}" />
            </if>

            <!-- Find matching assembly info files -->
            <fileset id="assemblyInfoSet">
                <include name="**/Properties/*AssemblyInfo.cs" />
            </fileset>
            
            <!-- Loop through the matching files -->
            <foreach item="File" property="filename">
                <in>
                    <items refid="assemblyInfoSet" />
                </in>
                <do>				
                    <loadfile file="${filename}" property="assemblyContent" />

                    <property name="major" value="0" />
                    <property name="minor" value="0" />
                    <property name="revision" value="" />
                    <property name="build" value="" />
                    <property name="before" value="" />
                    <property name="after" value="" />

                    <!-- Replace the AssemblyVersion -->
                    <regex input = "${assemblyContent}"
                        failonerror = "false"
                        pattern = "(?'before'[\w\s\W]*)?\[assembly: AssemblyVersion\(&quot;(?'major'\d+)(\.(?'minor'\d+))(\.((?'revision'\d+)|(\*)))?(\.((?'build'\d+)|(\*)))?&quot;\)\](?'after'[\w\s\W]*)?" />

                    <echo message="${filename} - Major.Minor.Revision.Build: ${major}.${minor}.${revision}.${build}" />

                    <!-- Modify the Version -->
                    <if test="${property::exists('RevisionNumber')}">
                        <property name="AssemblyVersion" value="${major}.${minor}.${BuildNumber}.${RevisionNumber}" />
                        <echo message="Setting up AssemblyVersion with RevisionNumber: ${AssemblyVersion}" />			
                    </if>
                    <if test="${not property::exists('RevisionNumber')}">
                        <property name="AssemblyVersion" value="${major}.${minor}.${BuildNumber}" />
                        <echo message="Setting up AssemblyVersion with BuildNumber: ${AssemblyVersion}" />			
                    </if>

                    <echo message="Updated Assembly Version: ${AssemblyVersion}" />

                    <!-- Augment the Version -->
                    <property name="assemblyContent" value="${before}[assembly: AssemblyVersion(&quot;${AssemblyVersion}&quot;)]${after}" />
                    
                    <!-- Write the modified version back to the file -->
                    <echo message="${assemblyContent}" file = "${filename}"/>
                </do>
            </foreach>
            
        </target>
    </project>
    ```
* Use this Docker base image in your build tools, e.g. TeamCity

## References
http://nant.sourceforge.net/