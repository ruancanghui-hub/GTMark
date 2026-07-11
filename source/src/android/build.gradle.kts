allprojects {
    repositories {
        google()
        mavenCentral()
        // 镜像仅作备用；放前面会导致 502 时拖垮整个依赖解析
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
    }
}

apply(from = "jvm_compat.gradle")

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    configurations.configureEach {
        resolutionStrategy {
            // home_widget 使用 glance 1.+，会拉到需 AGP 9.1 的 alpha；锁定 1.1.1
            force(
                "androidx.glance:glance-appwidget:1.1.1",
                "androidx.glance:glance:1.1.1",
            )
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
