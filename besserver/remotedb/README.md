Create a BigFix system with db2 running in a separate container - known as a BigFix remote db configuration.

The remote db configuration is not available with the BigFix evaluation edition.
Therefore this needs either a BigFix license authorization file or an existing production license.

The license files, either a license authorisation file or existing licence.pvk and license.crt should be placed in the license folder, from there they will be copied into the docker image.

To use existing and existing license set the docker environment `-e BES_INSTALL_FILE=bes-install-prod.rsp`.

To use a license authorization file set the docker environment  `-e BES_INSTALL_FILE=bes-install-auth.rsp`

By default all passwords are `BigFix1t4Me` and the inital BigFix user is `IEMAdmin`
