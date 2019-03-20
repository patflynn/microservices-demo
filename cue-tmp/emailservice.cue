package hipster

deployment emailservice: {
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
	metadata name: "emailservice"
	spec template: {
		metadata labels app: "emailservice"
		spec: {
			terminationGracePeriodSeconds: 5
			containers: [{
				name:  "server"
				image: "emailservice"
				ports: [{
					containerPort: 8080
				}]
				readinessProbe: {
					periodSeconds: 5
					exec command: ["/bin/grpc_health_probe", "-addr=:8080"]
				}
				livenessProbe: {
					periodSeconds: 5
					exec command: ["/bin/grpc_health_probe", "-addr=:8080"]
				}
				resources: {
					requests: {
						cpu:    "100m"
						memory: "64Mi"
					}
					limits: {
						cpu:    "200m"
						memory: "128Mi"
					}
				}
			}]
		}
	}
}
service emailservice: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "emailservice"
	spec: {
		type: "ClusterIP"
		selector app: "emailservice"
		ports: [{
			name:       "grpc"
			port:       5000
			targetPort: 8080
		}]
	}
}