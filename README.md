# hdinsight-drill

Run an Apache Drill cluster on Azure HDInsight

## Install and use Apache Drill on HDInsight Hadoop clusters

Install Apache Drill on Azure HDInsight using a Script Action.
A script to install Apache Drill (1.10) is available at:

    https://raw.githubusercontent.com/yaron2/hdinsight-drill/master/setup.sh

The script will work on both existing and new HDInsight clusters.
To install Apache Drill on a new cluster, perform the following steps:

1. From the __Cluster summary__ blade, select __Advanced settings__, then __Script actions__. Click __Submit new__ and choose __Custom__. Use the following to populate the form:

   * **NAME**: Enter a friendly name for the script action.
   * **SCRIPT URI**: https://raw.githubusercontent.com/yaron2/hdinsight-drill/master/setup.sh
   * **HEAD**: Don't check this option
   * **WORKER**: Check this option
   * **ZOOKEEPER**: Don't check this option
   * **PARAMETERS**: Leave this field blank

2. At the bottom of the **Script actions** blade, use the **Select** button to save the configuration. Finally, use the **Next** button to return to the __Cluster summary__

3. From the __Cluster summary__ page, select __Create__ to create the cluster.

## Using Drill on HDInsight

Drill is installed on all HDInsight Worker Nodes.
In order to connect with Drill, you need to obtain the IP address of any Worker node in the HDInsight cluster.

One way to do so is to open the Ambari Cluster Dashboard at HTTPS://CLUSTERNAME.azurehdidnsight.net where CLUSTERNAME is the name of your cluster.
Once logged in, click on Hosts, and obtain the ip address of any worker node that begins with wn.

In order to connect to the internal Worker nodes, setup SSH Tunneling and configure your browser as outlined here: https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-linux-ambari-ssh-tunnel

### Connect with drill shell

1. Connect to the HDInsight cluster using SSH:

    ```bash
    ssh USERNAME@CLUSTERNAME-ssh.azurehdinsight.net
    ```
2. Connect to one of the Worker nodes using SSH:

    ```bash
    ssh USERNAME@WORKER-NODE-IP
    ```
3. Start the Drill Shell:

    ```bash
     sudo ./var/lib/drill/apache-drill-1.10.0/bin/drill-conf
    ```
4. Verify everything's working with a simple SELECT to query the drillbits

    ```bash
    SELECT * FROM sys.drillbits;
    ```

### Using the Drill UI

After establishig the SSH tunneling, obtain an IP address of any Worker node as described above and go to http://node-ip:8047

### Using Azure Blob Storage

In order to query data from Azure Blob Storage, you first need to add it to the list of plugins.
To do so, connect to the Drill UI and navigate to the Storage page.

Then do the following:

1. Click on the Update button for the dfs plugin, and copy its contents.
2. Enter a name for your Azure account at the bottom of the page and click the Create button.
3. Delete the null value and paste the contents you copied earlier.
4. Change "file:///" to  "wasb://mycontainer@mydatafiles.blob.core.windows.net/" and change the container and account name accordingly.

See [here] for more info on Drill and Azure Blob Storage.

[here]: https://blogs.msdn.microsoft.com/data_otaku/2016/05/30/configuration-of-azure-blob-storage-aka-wasb-as-a-drill-data-source/




