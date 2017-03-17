# Module

TBD

## Testing

Test kitchen works in two steps: first you need to _converge_
(it will boot the machine and provision it with the provisioner of choice),
second you need to _verify_ (apply the test suit). You will usually converge
when you change the puppet and verify after every converge _or_ when adding new
tests. No need to converge if you only add tests.

    "The concept behind Test Kitchen is that it allows you
    to provision (convergence testing) an environment on a given platform
    (or platforms) and then execute a suite of tests to verify the environment has
    been set up as expected. But, as with software, you need to write effective
    tests – not just the assert(true) tests I see all too often." - https://goo.gl/9yovGL

This framework use test kitchen. All you have to run here for this project is

    kitchen command_1
    ..
    kitchen command_x

If you want to know more about test kitchen then visit https://goo.gl/TeGCEZ

### Override the tests

If you don't want to run all the tests, don't hack the main _.kitchen.yml_!
Instead create a simpler *.kitchen.local.yml* to override it.
To see and example of an override it just rename the file _.kitchen.local.yml.example_ to _.kitchen.local.yml_.

### Advices

To run all the test I would advice a machine with a lot of bandwidth and memory.

### Prerequisites

To make the testing work you need to have installed locally:

- docker
- a ruby env (possibly 2.4.0-dev)

Install all the test-kitchen dependencies run:

    $ bundle install

To check which ruby version you are using (only works with rbenv):

    $ rbenv global
    2.4.0-dev

### Check status

You can see the status of test-kitchen with:

    $ kitchen list
    Instance        Driver  Provisioner  Verifier  Transport  Last Action
    default-ubuntu  Docker  PuppetApply  Shell     Ssh        Verified

### Login into the docker container

It's a little starnge to login via test-kitchen in a docker container.
The usual _kitchen login_ command doesn't work. There is a script to do just
that already in the repo. If you have this machine:

    $ kitchen list
    Instance                            Driver  Provisioner  Verifier  Transport  Last Action
    solrcloud5-standalone-ubuntu-1404   Docker  PuppetApply  Shell     Ssh        Verified

Do the following:

    $ ./utilities/kl.sh solrcloud5-standalone-ubuntu-1404
    spawn kitchen login solrcloud5-standalone-ubuntu-1404
    Last login: Wed Sep 21 11:38:36 2016 from 172.17.0.1
    kitchen@ece63fe9bcba:~$

It should login automatically.
Use it from the root dir of this module.

### Validate puppet

Run:

    puppet-lint --no-autoloader_layout-check --FIX manifests/* && \
    puppet-lint --no-autoloader_layout-check --FIX test/\*.pp && \
    rake rubocop:auto_correct

### Validate puppet

Run:

    puppet-lint --no-autoloader_layout-check manifests/* && \
    puppet-lint --no-autoloader_layout-check test/\*.pp && \
    rake validate
    rake rubocop

### To test with with test-kitchen

Run:

    kitchen converge -c 999 && kitchen verify -c 999
