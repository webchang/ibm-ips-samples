# ibm-ips-samples
Sample browser based client that shows how to use IPS API.

* login.jsp shows how to use noop
* settings.jsp shows how to get settings
* simpleQuery.jsp shows how to get datasets, datalayers, polygons and then submit a query
* simpleJobs.jsp shows how to get status of queries if jobs are completed or not and how to get results for a completed job and overlay the results on OpenLayers map
* import.jsp shows the simple libraries needed to run the sample and also the URL used to access the IPS API

To see a running demo, use the following URL:
http://169.48.109.214:30466/openlayers-clients/login.jsp

and use these credentials on the login page:

IBMid:  ips.app@outlook.com
Password:  ips.app1

Client Id:  5c20d153-09ad-40e3-9387-124cd132bc42
Client Secret:  R8qP7dF2kH4fH4iH3lH2iJ7uD3yI2fQ5oY0cH8pE2kY3eN0cJ8

To see your settings including subscriptionId, adminIds, datasetPolicy, etc use the following URL:
http://169.48.109.214:30466/openlayers-clients/settings.jsp

To submit a query, use the following URL:
http://169.48.109.214:30466/openlayers-clients/simpleQuery.jsp

To see a quick demo, you can search for "green" to use USA - Iowa - Greene County (32) for polygon id, there is only one dataset at this time, SMT (Long term forecast) that you can use, you can choose any of the datalayers that show up under this dataset and choose snapshot such as 2016-02-01.
You will first get a popup saying your query is being processed and once you click ok, you should soon see a popup showing the job id for the job related to your query and the status. Copy this job id.

Now click on the Jobs page, http://169.48.109.214:30466/openlayers-clients/simpleJobs.jsp
You should be able to see your job id in the section Ongoing Jobs. Clicking on the job id will show the query related to it and also the status. Once your job completes, you should be able to see it in the Completed Jobs section (the page needs to be refreshed manually to keep the demo code simple). Clicking on the completed job will either show the status of the job if failed or retrieve the published layers from geoserver and display it as overlays on the OpenStreetMap.
