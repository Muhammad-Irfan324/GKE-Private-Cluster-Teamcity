
## Backup Volume Restore From Snapshot

`Link - https://stackoverflow.com/questions/60334589/how-to-clone-or-prepopulate-pvc-on-gke`

     - First Create Disk From Snapshot in order to create a Persistent Volume which can be used in manifest
     - In order to create a Disk from Snapshot go to compute engine > Disks and click on create disk 
     - set the name
     - select region and zone to europe-west2(london) & europe-west2-a 
     - check for source type and click on snapshot
     - select the source snapshot and choose the snapshot 
     - click on create disk
     - Once the disk is created use the created disk name in manifest under gcePersistentDisk > pdName 
     - After setting this adjust manifest according to your needs like metadata name, VolumeName or namespace
     - Once manifest is adjusted run command **kubectl apply -f restore-volume.yaml**
     - created new Persistent volume can be seen with the command **kubectl get pv**
     - once the volume is created simply change the manifest of either master or server and in section PersistentVolumeClaim > claimName set the name of the volume and re apply the manifest so that new volume can be mounted 

## Snapshot restore performed screenshots


![alt](https://github.com/Muhammad-Irfan324/GKE-Private-Cluster-Teamcity/blob/main/kubernetes/volume-snapshot-restore/Selection_382.png)

<br>

![alt](https://github.com/Muhammad-Irfan324/GKE-Private-Cluster-Teamcity/blob/main/kubernetes/volume-snapshot-restore/Selection_385.png)

<br>

![alt](https://github.com/Muhammad-Irfan324/GKE-Private-Cluster-Teamcity/blob/main/kubernetes/volume-snapshot-restore/Selection_384.png)

<br>

![alt](https://github.com/Muhammad-Irfan324/GKE-Private-Cluster-Teamcity/blob/main/kubernetes/volume-snapshot-restore/Selection_383.png)

<br>

![alt](https://github.com/Muhammad-Irfan324/GKE-Private-Cluster-Teamcity/blob/main/kubernetes/volume-snapshot-restore/Selection_386.png)

 <br> 

