package hipster

deployment frontend: {
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
	metadata name: "frontend"
	spec template: {
		metadata labels app: "frontend"
		spec containers: [{
			name:  "server"
			image: "frontend"
			ports: [{
				containerPort: 8080
			}]
			readinessProbe: {
				initialDelaySeconds: 10
				httpGet: {
					path: "/_healthz"
					port: 8080
					httpHeaders: [{
						name:  "Cookie"
						value: "shop_session-id=x-readiness-probe"
					}]
				}
			}
			livenessProbe: {
				initialDelaySeconds: 10
				httpGet: {
					path: "/_healthz"
					port: 8080
					httpHeaders: [{
						name:  "Cookie"
						value: "shop_session-id=x-liveness-probe"
					}]
				}
			}
			env: [{
				name:  "PRODUCT_CATALOG_SERVICE_ADDR"
				value: "productcatalogservice:3550"
			}, {
				name:  "CURRENCY_SERVICE_ADDR"
				value: "currencyservice:7000"
			}, {
				name:  "CART_SERVICE_ADDR"
				value: "cartservice:7070"
			}, {
				name:  "RECOMMENDATION_SERVICE_ADDR"
				value: "recommendationservice:8080"
			}, {
				name:  "SHIPPING_SERVICE_ADDR"
				value: "shippingservice:50051"
			}, {
				name:  "CHECKOUT_SERVICE_ADDR"
				value: "checkoutservice:5050"
			}, {
				name:  "AD_SERVICE_ADDR"
				value: "adservice:9555"
			}]
			// - name: JAEGER_SERVICE_ADDR
			//   value: "jaeger-collector:14268"
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
service frontend: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "frontend"
	spec: {
		type: "ClusterIP"
		selector app: "frontend"
		ports: [{
			name:       "http"
			port:       80
			targetPort: 8080
		}]
	}
}
service "frontend-external": {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "frontend-external"
	spec: {
		type: "LoadBalancer"
		selector app: "frontend"
		ports: [{
			name:       "http"
			port:       80
			targetPort: 8080
		}]
	}
}
