Creating a Couchbase Server database service in Application Director

The set of scripts in this GitHub repository help you to create a Couchbase Server database service in vFabric Application Director.

The two scripts correspond to the two lifecycle stages of a service:

* cb-install.sh: Installs Couchbase Server using an RPM from the Couchbase Downloads site
* cb-configure.sh: Configures the Couchbase Server by automatically clustering all Couchbase nodes in the deployment and creating a default bucket

You do not need to run these scripts yourself.  Rather, you specify their contents when you create a new service using the Application Direcotr Wizard.  

Note: Because it is assumed that you already know how to use Application Director, the following procedures concentrate on showing specific vFabric Web Server information rather than detailed steps about using the user interface. See the documentation for general information about using Application Director.

To create a Couchbase Server database service in vFabric Application Director, follow these steps:

1.  Add a new service to the catalog.
2.  When entering details about the new service, use the following values, as shown in this screenshot: https://github.com/alexmacouchbase/appdirector/blob/master/cb-details.png
3.  Add the following required Properties to the service, as show in this screenshot:
https://github.com/alexmacouchbase/appdirector/blob/master/cb-properties.png

<table border="1">
<tr>
<th style="background-color:#F0F0F0">Property Name</th>
  <th style="background-color:#F0F0F0">Type</th>
  <th style="background-color:#F0F0F0">Value</th>
</tr>
<tr>
<td>ssh_port                    </td><td>String         </td><td> 80</td></tr><tr>
<td>node_array_index       </td><td>String     </td><td></td></tr><tr>
<td>console_password     </td><td>String       </td><td>   couchbase123</td></tr><tr>
<td>ssh_password          </td><td>String        </td><td>  couchbase123</td></tr><tr>
<td>couchbase_port          </td><td>String    </td><td> 8080</td></tr><tr>
<td>cluster_ips               </td><td>Array</td><td></td></tr><tr>
<td>replica_count         </td><td> String        </td><td>  1</td></tr><tr>
<td>bucket_type              </td><td> String     </td><td>couchbase</td></tr><tr>
<td>bucket_name         </td><td> String         </td><td> default</td></tr><tr>
</table>

Leave the values of node_array_index and cluster_ips blank.  These will be set at deploy time through app directors built in paramaters.  Use default values for the other columns as shown.


Creating and Deploying an Application that uses a Couchbase Server database Service


test
