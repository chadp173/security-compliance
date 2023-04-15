#!/usr/bin/env bash 
ART=bluefringe-docker-local.artifactory.swg-devops.com
ICR=us.icr.io/bluefringe
TAG="{date +%Y%e%d}"


bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_svc                     20201006            fca7b3517a98        43 minutes ago      1.6GB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_uep_svc                 20201006            c4afac3e23e8        44 minutes ago      1.54GB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_policy_approve       20201006            3e1ea1b1b9cb        46 minutes ago      943MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_policy_check         20201006            06191f3c3618        48 minutes ago      910MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_ipassign             20201006            31db2f1633d6        50 minutes ago      910MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_fromsl               20201006            92a622e28bbe        52 minutes ago      925MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_att120               20201006            c57a4ff5df45        57 minutes ago      910MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_att_diag             20201006            c57a4ff5df45        57 minutes ago      910MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_expand               20201006            1def8b6d8cd5        About an hour ago   910MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/keystone                       20201006            2c14e0650934        About an hour ago   1.28GB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/base_keystone                  20201006            a0fa1c365a4d        5 days ago          1.17GB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_analytics_svc           20201006            3479ed9bc9f5        About an hour ago   1.54GB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/vault_client                   20201006            f9a2037b88fa        About an hour ago   400MB
bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/core-deploy-tools              20201006            edeb320d962a        2 hours ago         1.21GB
bluefringe-docker-local.artifactory.swg-devops.com/cio-bluefringe/fringe_rdb                    20201006            732e82da5615        13 days ago         3.39GB

(base) Chads-MacBook-Pro:core-deploy-tools chad.perry1$ docker images|grep 1006| grep icr
us.icr.io/bluefringe/fringe_svc                                                                 20201006            fca7b3517a98        52 minutes ago      1.6GB
us.icr.io/bluefringe/fringe_uep_svc                                                             20201006            c4afac3e23e8        53 minutes ago      1.54GB
us.icr.io/bluefringe/fringe_de_policy_approve                                                   20201006            3e1ea1b1b9cb        55 minutes ago      943MB
us.icr.io/bluefringe/fringe_de_policy_check                                                     20201006            06191f3c3618        57 minutes ago      910MB
us.icr.io/bluefringe/fringe_de_ipassign                                                         20201006            31db2f1633d6        59 minutes ago      910MB
us.icr.io/bluefringe/fringe_de_fromsl                                                           20201006            92a622e28bbe        About an hour ago   925MB
us.icr.io/bluefringe/fringe_de_att120                                                           20201006            c57a4ff5df45        About an hour ago   910MB
us.icr.io/bluefringe/fringe_de_att_diag                                                         20201006            c57a4ff5df45        About an hour ago   910MB
us.icr.io/bluefringe/fringe_de_expand                                                           20201006            1def8b6d8cd5        About an hour ago   910MB
us.icr.io/bluefringe/keystone                                                                   20201006            2c14e0650934        About an hour ago   1.28GB
us.icr.io/bluefringe/fringe_analytics_svc                                                       20201006            3479ed9bc9f5        About an hour ago   1.54GB
us.icr.io/bluefringe/vault_client                                                               20201006            f9a2037b88fa        About an hour ago   400MB
us.icr.io/bluefringe/core-deploy-tools                                                          20201006            edeb320d962a        2 hours ago         1.21GB
us.icr.io/bluefringe/base_keystone                                                              20201006            a0fa1c365a4d        5 days ago          1.17GB
us.icr.io/bluefringe/fringe_rdb                                                                 20201006            732e82da5615        13 days ago         3.39GB