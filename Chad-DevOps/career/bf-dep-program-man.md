

    List of steps when deploying new code base to production. 
 

1. Notify users in Slack users channel (Jenkins job with template) 
    - slack-announcement-after-prod-maintenance-notification 
    <br/> a. Sends message to slack channels: 
      - cio-bluefringe-dev 
      - cio-bluefringe-sup 
      - cio-bluefringe-users **Most important channel**

2. Any DB changes
    - SRE Task to be verified in Rancher 

3. Promote images to GOLD in Jenkins (SILVER to GOLD)
      - core_ci_stage_promote
      - web_ci_stage_promote
      - svc_ci_stage_promote

4. Check if Jenkins code is up to date Ranchers (SRE)
    <br/> a. SRE Team will login to Ranchers to get IP of the machine 
      
    - core_ci_stage_promote
    - web_ci_stage_promote
    - svc_ci_stage_promote

5. Patch nodes: Inactive app node first via Rancher 
    - core_ci_stage_promote
    - web_ci_stage_promote
    - svc_ci_stage_promote

a. SRE Team will run Ansible Playbooks against the nodes

6. Clean Docker resources on inactive side

7. Prepare box from Docker side to speed up prepare deployment step      
- **NOTE: Cleaning Docker resources can take 5s to 20min**

8. Pull images (to decrease downtime)  

9. Flip sides in Rancher and stop containers (Jenkins job)
    - stage_stop_container_flip
    - prod_deployment_flip_lb

10. Apply Rancher configs (Ansible) check LB rules (are they up to date?)

11. Start deployment on new side Jenkins Job
- prod_deployment_side-b 
- prod_deployment_side-a 
**This depends on which side is active first**

12. Flip engines checks (Jenkins)  checking data engines like policy_check for errors, 
- check-datdaengine-nso-errors-prod-side-[a/b]
- check-datdaengine-policy-check-prod-side[a/b]
- check-datdaengine-svc-error-prod-side[a/b]
**This depends on which side is active**

13. Test new areas

14. Notify users (Jenkins job with template) slack-announcement-after-prod-maintenance-notification

15. After monitoring for few cycles - Start DE_ATT edit-config connector  make sure that few cycles passed and no deletion/changes occur in policy check/approve data engine