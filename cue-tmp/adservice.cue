package hipster

deployment adservice: {
	// Copyright 2018 Google LLC
	//
	// Licensed under the Apache License, Version 2.0 (the "License");
	// you may not use this file except in compliance with the License.
	// You may obtain a copy of the License at
	//
	//      http://www.apache.org/licenses/LICENSE-2.0
	//
	// Unless required by applicable law or agreed to in writing, software
	// distributed under the License is distributed on an "AS IS" BASIS,
	// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	// See the License for the specific language governing permissions and
	// limitations under the License.
	apiVersion: "extensions/v1beta1"
	kind:       "Deployment"
	metadata name: "adservice"
	spec template: {
		metadata labels app: "adservice"
		spec: {
			terminationGracePeriodSeconds: 5
			containers: [{
				name:  "server"
				image: "adservice"
				ports: [{
					containerPort: 9555
				}]
				env: [{
					name:  "PORT"
					value: "9555"
				}]
				//- name: JAEGER_SERVICE_ADDR
				//  value: "jaeger-collector:14268"
				resources: {
					requests: {
						cpu:    "200m"
						memory: "180Mi"
					}
					limits: {
						cpu:    "300m"
						memory: "300Mi"
					}
				}
				readinessProbe: {
					initialDelaySeconds: 20
					periodSeconds:       15
					exec command: ["/bin/grpc_health_probe", "-addr=:9555"]
				}
				livenessProbe: {
					initialDelaySeconds: 20
					periodSeconds:       15
					exec command: ["/bin/grpc_health_probe", "-addr=:9555"]
				}
			}]
		}
	}
}
service adservice: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "adservice"
	spec: {
		type: "ClusterIP"
		selector app: "adservice"
		ports: [{
			name:       "grpc"
			port:       9555
			targetPort: 9555
		}]
	}
}
