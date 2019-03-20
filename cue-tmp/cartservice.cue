package hipster

deployment cartservice: {
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
	metadata name: "cartservice"
	spec template: {
		metadata labels app: "cartservice"
		spec: {
			terminationGracePeriodSeconds: 5
			containers: [{
				name:  "server"
				image: "cartservice"
				ports: [{
					containerPort: 7070
				}]
				env: [{
					name:  "REDIS_ADDR"
					value: "redis-cart:6379"
				}, {
					name:  "PORT"
					value: "7070"
				}, {
					name:  "LISTEN_ADDR"
					value: "0.0.0.0"
				}]
				resources: {
					requests: {
						cpu:    "200m"
						memory: "64Mi"
					}
					limits: {
						cpu:    "300m"
						memory: "128Mi"
					}
				}
				readinessProbe: {
					initialDelaySeconds: 15
					exec command: ["/bin/grpc_health_probe", "-addr=:7070"]
				}
				livenessProbe: {
					initialDelaySeconds: 15
					periodSeconds:       10
					exec command: ["/bin/grpc_health_probe", "-addr=:7070"]
				}
			}]
		}
	}
}
service cartservice: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "cartservice"
	spec: {
		type: "ClusterIP"
		selector app: "cartservice"
		ports: [{
			name:       "grpc"
			port:       7070
			targetPort: 7070
		}]
	}
}
