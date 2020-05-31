# Yelp-detect-secrets quick Makefile setup

To use the makefile to setup [Yelp/detect-secrets](https://github.com/Yelp/detect-secrets) to scan your repository before every commit, you can follow the following steps

----

## For DevOps / Administrators to setup required files in a repository

1. Clone this repository first
```
git clone git@github.com:Weiyuan-Lane/precommit-setup-exp.git
```

2. Call the Makefile from the root directory of your target repository, and trigger the install instruction
```
make -f ~/%YOUR_DIRECTORY%/precommit-setup-exp/Makefile install
```

With the newly generated config in your repository, commit the files. That's it!

----

## For regular developers

1. Clone this repository first
```
git clone git@github.com:Weiyuan-Lane/precommit-setup-exp.git
```

2. Add the pre-commit hooks to your local environment, calling the following from the root path of your target repository
```
make -f ~/%YOUR_DIRECTORY%/precommit-setup-exp/Makefile addDetectSecrets
```

That's it, for every commit, the repository will be scanned for new addition of secrets

----

### To uninstall

Run the following command from your repository
```
make -f ~/%YOUR_DIRECTORY%/precommit-setup-exp/Makefile uninstall
```

