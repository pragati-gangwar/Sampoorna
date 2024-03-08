# <center><h1 align="center"> SAMPOORNA <br/> <img src='assets/images/Logo.jpeg' width="150" height="150"> </h1></center>
### <center><p align="center"><i>Completeness Through Inclusivity</i></p></center>

<br> 

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [About the project](#about-the-project)
   - [Video Link](#detailed-video-link)
   - [UN 17 Goals](#un-17-goals)
   - [Salient features](#salient-features)
3. [Technology Stack](#technology-stack)
4. [Compatibility](#compatibility)
5. [Tour through the App](#tour-through-the-app)
6. [Flow of the app](#flow-of-the-app)
7. [Implementation of Agile Methodology](#implementation-of-agile-methodology)
8. [Installation](#installation)
9. [Special Instructions to Work with the App](#special-instructions-to-work-with-the-app)
10. [Challenges Faced](#challenges-faced)
11. [Future Scope](#future-scope)
12. [Support and Contact](#future-scope)

## Problem Statement
    
In today's society, individuals with disabilities face numerous challenges, including limited access to essential services and a lack of volunteer support. The emotional toll of navigating daily life under these circumstances is significant. Existing applications often fail to adequately address the multifaceted needs of this community. Hence, there is a critical need for a dedicated solution that actively tackles these issues, providing a secure and supportive environment for individuals with disabilities.
 
[(Back to the top)](#-Sampoorna--)

## About the project

Our project is dedicated to empowering individuals with disabilities by providing a comprehensive application focused on safety, inclusivity, and empowerment. In addition to fostering connections and accessing resources, our app prioritizes mental safety through features like Medicare and SOS. By offering a holistic approach to support, we aim to enhance the overall well-being and quality of life for our users .
### Detailed Video Link 
[Video](https://drive.google.com/file/d/111IIwF8BKKPQE5E7nwStyRVviHRraSkM/view)

### UN 17 Goals 

<p align="center">
<span>

</span>
 </p>

- Our target is to achieve gender equality and empower all people with disability. 
We are fulfilling: <br/>
**Goal 3**: Good Health and Well-being: Sampoorna promotes the physical and mental well-being of individuals with disabilities by offering features such as Medicare, which helps users manage their healthcare needs, including prescriptions and medical records. Additionally, the mood tracking feature contributes to monitoring and improving mental health, ensuring that users have access to resources and support to maintain overall well-being.
<br/>  **Goal 10**: Reduced Inequalities: By focusing on inclusivity and empowerment, your app aims to reduce inequalities faced by individuals with disabilities. Through features like Connect Me, users can access counselors, volunteers, and NGOs for personalized support, thereby bridging the gap in access to essential services. Furthermore, the recommendation feature encourages the creation of disabled-friendly environments, promoting inclusivity and accessibility in communities.
<br />


### Salient Features

**Connect Me**: Facilitates connections with counselors, nearby volunteers, and NGOs for personalized support and assistance.<br/>
**Education and Mood Tracking:** Offers a diverse range of educational content accessible in various formats, accompanied by a mood tracking feature to monitor emotional well-being.
<br/>
**Report and Recommendation**: Empowers users to recommend disabled-friendly locations and services, promoting inclusivity and accessibility. <br/>
**Medicare**: Streamlines healthcare management by enabling users to maintain medical records, set prescription reminders, and access healthcare services conveniently. <br/>
**Community**: Fosters a supportive online community where users can connect with peers facing similar challenges, share experiences, and provide mutual support. <br/>
**Feed**: Provides a platform for users to share personal insights, stories, and resources through blog posts, fostering community engagement and empowerment. <br/>
**SOS**: Implements an emergency alert system that enables users to swiftly notify designated contacts of their distress and share their live location for immediate assistance. <br/>
**Chatbot**: Offers AI-powered assistance to users, providing information, guidance, and support in real-time. <br/>


[(Back to the top)](#-Sampoorna--)

## Technology Stack

<p align="center">
<span>
<img src='assets/images/Tech1.jpeg' width="120" height="80">
<img src='assets/images/Tech2.jpeg' width="120" height="80">
<img src='assets/images/Tech3.jpeg' width="120" height="80">
<img src='assets/images/Tech4.jpeg' width="120" height="80">
<img src='assets/images/Tech5.jpeg' width="120" height="80">
<img src='assets/images/Tech6.jpeg' width="120" height="80">

</span>
 </p>

- Flutter and Dart were used to develop the application.
- Necessary packages were imported from pub.dev.
- The backend has been implemented using Firebase. (Firebase authentication, Firestore and Firebase Storage have been used).
- Access to live location using geolocator and Google Maps plugins.
- The locations have been fetched using Google Maps.
- Google DialogFlow is used for implementing chat bot support.
- Helpbot support with Google DialogFlow.
- AI-powered chatbot support using Google Gemini bot.


[(Back to the top)](#-Sampoorna--)


## Compatibility

The flutter application is compatible to run on android smart phones.

[(Back to the top)](#-Sampoorna--)


## Tour through the App
- <h3>Onboarding Screens</h3>
<p align="left">
  <figure>
  <kbd><img src="assets/images/sa.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Access Location Permission</p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
  <kbd><img src="assets/images/sb.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <figure>
  <kbd><img src="assets/images/sc.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <figure>
  <kbd><img src="assets/images/sd.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
      <figure>
  <kbd><img src="assets/images/se.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
      <figure>
  <kbd><img src="assets/images/sf.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
</p>
<hr>
      
- <h3> User Authentication Screens</h3>
<p align="left">
   <figure style="padding-right: 20px;" >
  <kbd><img src="assets/images/authentication1.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Login Screen</p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <figure>
  <kbd><img src="assets/images/authentication2.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">Create Account </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
  <kbd><img src="assets/images/authentication3.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Types of Disabilities</p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <figure>
  <kbd><img src="assets/images/authentication4.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Forgot Password Screen</p></figcaption></div>
     </figure
         <figure>
  <kbd><img src="assets/images/authentication5.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> E-mail Verification</p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/authentication6.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/authentication7.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/authentication8.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Safety Call</p></figcaption></div>
     </figure>
 </p>    

<hr>
- <h3> Dashboard Screens</h3>
<p align="left">
   <figure style="padding-right: 20px;" >
  <kbd><img src="assets/images/Dashboard1.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <figure>
  <kbd><img src="assets/images/Dashboard2.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
  <kbd><img src="assets/images/Dasboard3.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <figure>
  <kbd><img src="assets/images/Dashboard4.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  n</p></figcaption></div>
     </figure
         <figure>
  <kbd><img src="assets/images/Dashboard5.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/Dashboard6.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/Dashboard7.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>
      <figure>
  <kbd><img src="assets/images/Dashboard8.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px">  </p></figcaption></div>
     </figure>
 </p>    

<hr>
- <h3>Features</h3>    
 <h3> SOS</h3>
<p align="left">
   <figure style="padding-right: 20px;" >
  <kbd><img src="assets/images/SOS1.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <figure>
  <kbd><img src="assets/images/SOS2.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> </p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
  <kbd><img src="assets/images/SOS3.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"> Education</p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <figure>
 </p>    

<hr>

 <h3> Report and Recommendation</h3>
<p align="left">
   <figure style="padding-right: 20px;" >
  <kbd><img src="assets/images/RR1.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"></p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <figure>
  <kbd><img src="assets/images/RR3.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"></p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
   <kbd><img src="assets/images/RR4.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"></p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       <figure>
   <kbd><img src="assets/images/RR2.jpeg" height='300' width='150'/>
   <div><figcaption> <p align="center" style="font-size:100px"></p></figcaption></div>
     </figure>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <figure>
 </p>    
<hr>


    
    
    
## Flow of the App
<p align="center"><img src='assets/images/Workflow.jpeg' width="800" height="370"></p>

[(Back to the top)](#-shakti--)
    
    
## Implementation of Agile Methodology

### What is Agile?
Agile is a development methodology adopted today in the software industry. Agile promotes teamwork, flexible procedures, and sle-organizing teams.

### How we incorporated Agile Methodology during the development cycle?
SCRUM is a subset of Agile, a framework for developing software.The basic time working unit is the sprint. SCRUM teams always reason in sprints and their planning is limited to sprints.

- Sprint 1: *Research and Design*
- Sprint 2: *Building the application*
- Sprint 3: *Testing and debugging* 
     
    
### How it helped us?

- It made the app development process more efficient and predictable.
- We worked on functionalities looking at them as smaller units of the larger app due to which the process was easy to handle, flexible and allowed more room to adjust new functionalities.

[(Back to the top)](#-shakti--)
    

## Installation

Initialise git on your terminal:

git init

<br>

Clone this repository:
 
git clone https://github.com/pragati-gangwar/Sampoorna

<br>

Change the directory.

cd Sampoorna/

      
<br>
      
      
Run the packages get command in your project directory:


flutter pub get


<br>

Once the build is complete, run the run command to start the app:


flutter run


In case you encounter the error A problem occurred evaluating project ':tflite',

you should change this on ~\tflite-1.1.2\android\build.gradle:


dependencies {
    compile 'org.tensorflow:tensorflow-lite:+'
    compile 'org.tensorflow:tensorflow-lite-gpu:+'
}

to this:

dependencies {
    implementation 'org.tensorflow:tensorflow-lite:+'
    implementation 'org.tensorflow:tensorflow-lite-gpu:+'
} 


[(Back to the top)](#-shakti--)
    
## Special Instructions to Work with the App

1. The application can only be run on android physical devices. Due to the app being heavy, it would not work on virtual emulators smoothly.

2. Permission to use Camera, Location, Contacts, Messaging etc should be given whenever prompted.

[(Back to the top)](#-Sampoorna--)

## Challenges Faced
1. The features decided to serve as small applications in themselves- grouping together would be a major task by selecting the appropriate technology.
2. The flutter depreciations, the amount of load an application takes, and updations in firebase were also taken into consideration.
3. Another challenge was to select UI theme as it should be appealing to attract specially abled people to the app. It should reflect feeling of being at peace, safe, 
   strong, and empowered. Our users should feel comfortable while using the app.

[(Back to the top)](#-Sampoorna--)
    
## Future Scope
<p>
Personalized Dashboards for Diverse Disabilities: <br/>
- Introduce disability-specific dashboards catering to various disabilities, offering customized content and features.<br/>
Dual Interfaces for User and Volunteer Registration: <br/>
- Expand the app to feature two distinct interfaces – one for users with disabilities and another for volunteers and medical professionals during the registration process.<br/>
Future Job Listings: <br/>
 - Plan for a job listing section that caters to disability-friendly employment opportunities, promoting economic empowerment. <br/>
Tailored Content Curation: <br/>
- Implement machine learning algorithms for personalized content delivery, curating news, blogs, and NGO information based on individual disability profiles.

</p>


[(Back to the top)](#-Sampoorna--)

.
