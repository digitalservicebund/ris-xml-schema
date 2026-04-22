import org.gradle.api.publish.maven.MavenPublication

plugins {
    base
    `java-library`
    `maven-publish`
}

group = "de.bund.digitalservice"
version = System.getenv("RELEASE_VERSION") ?: "0.0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

dependencies {}

val packageSchemas = tasks.register<Jar>("packageSchemas") {
    description = "Copies the schema files into the jar."
    group = "build"

    from("xsd") {
        include("**/*.xsd")
        into("schema")
    }
}

tasks.assemble {
    dependsOn(packageSchemas)
}

repositories {
    mavenCentral()
    gradlePluginPortal()
    maven {
        setUrl("https://plugins.gradle.org/m2/")
    }
}

publishing {
  repositories {
    maven {
      name = "GitHubPackages"
      url = uri("https://maven.pkg.github.com/digitalservicebund/ris-xml-schema")
      credentials {
        username = System.getenv("GITHUB_ACTOR")
        password = System.getenv("GITHUB_TOKEN")
      }
    }
  }
  publications {
    create<MavenPublication>("gpr") {
      from(components["java"])
    }
  }
}
