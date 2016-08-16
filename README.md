# UrbanCode Deploy Canary Sample Application #

The canary application can serve as a [sentinel]( https://en.wikipedia.org/wiki/Sentinel_species),
helping you detect danger in your UrbanCode environment. It defines an application, component,
and environment in your UrbanCode server. The application installs a file of random data on the
target system, the **canaryfile**, into /tmp/canaryTest. The default canaryFile size is **10M**,
but its size can be determined at install time. *Neither canaries nor applications were harmed in
the production of this sample.*

# Installing the Canary on a system you use for component imports

- Install the [udclient](https://www.ibm.com/support/knowledgecenter/SS4GSP_6.2.1/com.ibm.udeploy.reference.doc/topics/cli_install.html)
package and add it to your PATH.
- Clone this repository.
- Create an authorization token [by CLI](https://www.ibm.com/support/knowledgecenter/SS4GSP_6.2.1/com.ibm.udeploy.api.doc/topics/udclient_createauthtoken.html) or the [GUI](https://www.ibm.com/support/knowledgecenter/SS4GSP_6.2.1/com.ibm.udeploy.admin.doc/topics/security_token.html) in your UrbanCode Deploy server.
- Run **bin/ucd-canary.sh** --authtoken  <*token*>  --weburl <*ucd-url*> on a system you have a component import agent.
- Review the udclient output to ensure all steps were successful.
- Log into your UrbanCode Deploy server to add an agent to the **Aviary** resource.
- Add the **Canary Component** to your agent.

# Running the Canary deployment process

- **Request Process** on the **Birdcage** environment.
- uncheck "Only Changed Versions" on the **Run Process on Birdcage** dialog.
- Choose "Latest Available" Component Versions.
- **Schedule Deployment** daily to keep your sentinal on daily duty.
- Submit.

# Contributing to the Canary Application

Use the Github issue tracker to report problems with this sample application.
Contributions are very welcome by pull request to this repository subject to the
[Developer's Certificate of Origin](license/DCO1.1.txt).


# License

The carary application files and associated scripts found in this project are licensed under the [Apache License 2.0](license/LICENSE.txt).


