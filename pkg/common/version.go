package common

const(
	qkeVersion = "unknown"
	kubeSphereVersion = "v2.1.0"
	qingCloudCSIVersion = "v1.1.0"
	etcdVersion = "v3.2.24"
	calicoVersion = "v3.8.2"
	flannelVersion = "v0.11.0"
	cloudControllerManagerVersion = "v1.4.0"
	dockerVersion = "v18.06.2-ce"
	osVersion = "ubuntu 18.04.2"

)

type Version struct{
	QKEVersion string `json: qkeVersion`
	KubeSphereVersion string `json:kubeSphereVersion`
	QingCloudCSIVersion string `json: qingCloudCSIVersion`
	EtcdVersion string `json: etcdVersion`
	CalicoVersion string `json: calicoVersion`
	FlannelVersion string `json: flannelVersion`
	CloudControllerManagerVersion string `json: cloudControllerManagerVersion`
	DockerVersion string `json: dockerVersion`
	OSVersion string `json: osVersion`
}

func Get()Version{
	return Version{
		QKEVersion: qkeVersion,
		KubeSphereVersion: kubeSphereVersion,
		QingCloudCSIVersion: qingCloudCSIVersion,
		EtcdVersion: etcdVersion,
		CalicoVersion: calicoVersion,
		FlannelVersion: flannelVersion,
		CloudControllerManagerVersion:cloudControllerManagerVersion,
		DockerVersion: dockerVersion,
		OSVersion:osVersion,
	}
}