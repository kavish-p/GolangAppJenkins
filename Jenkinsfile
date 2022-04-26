pipeline {
  
    agent {
        kubernetes {
            cloud 'kavish-test'
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: oc
                image: 10.168.0.76:9000/dev-registry/oc-jenkins:1.5
                command:
                - cat
                tty: true
              imagePullSecrets:
              - name : nexus-secret
              volumeMounts:
              - mountPath: "/jenkins"
                name: oc-jenkins-agent-pvc
            '''
        }
    }
    
    environment {
        OCP_SERVICEACCOUNT = credentials('ocp-sa-kavish-test')
    }
    
    stages {
        
        stage('Generate Version Number') {
            steps {
                echoBanner("Generate Version Number", ["Generating semantic version number"])
                container('oc') {
                    script {
                        VERSION = sh(returnStdout: true, script: 'gitversion | jq ".SemVer"').trim()
                    }
                    sh "echo ${VERSION}"
                }
            }
        }

        stage('Deploy to DEV') {
            when {
                branch 'develop'  
            }
            steps {
                echoBanner("Deploy to DEV", ["Deploy to DEV"])
                container('oc') {
                    echo "This is simulating deployment to DEV"
                }
            }
        }

        stage('Deploy to PROD') {
            when {
                branch 'master'  
            }
            steps {
                echoBanner("Deploy to PROD", ["Deploy to PROD"])
                container('oc') {
                    echo "This is simulating deployment to PROD"
                }
            }
        }
        
    }
}



def echoBanner(def ... msgs) {
   echo createBanner(msgs)
}

def errorBanner(def ... msgs) {
   error(createBanner(msgs))
}

def createBanner(def ... msgs) {
   return """
       ===========================================

       ${msgFlatten(null, msgs).join("\n        ")}

       ===========================================
   """
}

// flatten function hack included in case Jenkins security
// is set to preclude calling Groovy flatten() static method
// NOTE: works well on all nested collections except a Map
def msgFlatten(def list, def msgs) {
   list = list ?: []
   if (!(msgs instanceof String) && !(msgs instanceof GString)) {
       msgs.each { msg ->
           list = msgFlatten(list, msg)
       }
   }
   else {
       list += msgs
   }

   return  list
}
