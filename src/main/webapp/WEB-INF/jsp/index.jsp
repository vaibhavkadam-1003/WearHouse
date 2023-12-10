<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Google font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">

<!-- Fontawesome cdn link -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />

<title>Pluck</title>

<link href="${pageContext.request.contextPath}/css/landing.css"
	rel="stylesheet">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
.badge-soft-primary {
	color: #13a03b;
	font-size: 0.7rem;
	border: 1px solid #198754;
}

.nav-item{
	margin:0px 10px;
}

#contact-form input ,#contact-form button{
	margin:10px 0px;
}
</style>
</head>

<body data-spy="scroll" data-target="#ftco-navbar" data-offset="200">

	<nav
		class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light "
		id="ftco-navbar"
		style="position: fixed; top: 0; padding: 5px 5px 5px 80px; height: 70px; width: 100%">
		
		<div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
			<a class="navbar-brand" href="#">
			<div style="background-color: white; border-radius: 25px">
			<img src="${pageContext.request.contextPath}/images/apps_logo.png"
					alt="Pluck Logo" class="img-fluid" width="120px" height="50px" />
			</div>
			
			<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#ftco-nav" aria-controls="ftco-nav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="oi oi-menu"> </span> Menu
		</button>
			
		</a>
		
		<!-- <div class="collapse navbar-collapse" id="ftco-nav"style="margin-right: 20px"> -->
			<ul class="navbar-nav ml-auto">
				<li class="nav-item active"><a style="font-size: 20px"
					href="#section-home" class="nav-link">Home</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-introduction" class="nav-link">Introduction</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-dashboard" class="nav-link">Dashboard</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-features" class="nav-link">Features</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-pricing" class="nav-link">Pricing</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-about" class="nav-link">About</a></li>
				<li class="nav-item"><a style="font-size: 20px"
					href="#section-contact" class="nav-link">Contact</a></li>
				

			</ul>
			
			<ul class="navbar-nav ml-auto">
					<li style="" class="nav-item"><a
					href="${pageContext.request.contextPath}/login"
					class="btn btn-success">Login</a></li>
				<li style="" class="nav-item"><a
					href="${pageContext.request.contextPath}/signUp"
					class="btn btn-success">SignUp</a></li>
				</ul>
				
			
		<!-- </div> -->
		<div>
				
			</div>
		
		</div>

	</nav>

	<header class=" bg-light " id="section-home">
		<div id="header-container">
			<div id="header-page-title">
				<h2>Pluck</h2>
				<p>The Pluck is a project management system which manages all
					the different resources and aspects of the project in such a way
					that the resources will deliver all the output that is required to
					complete the project within the defined scope and time. The test
					suite module of the application allows users to configure and run
					automatic test cases that report the test execution status.</p>
			</div>
			<div id="header-page-image">
				<img
					src="${pageContext.request.contextPath}/images/Landing_Img_01.png"
					alt="">
			</div>
		</div>
	</header>


	<section class="ftco-section bg-light  ftco-slant ftco-slant-white"
		id="section-features">

		<div class="col-md-12  text-center mb-5">
			<h2 class="text-uppercase ftco-uppercase font-effect-fire heading"
				style="color: #000094; font-size: 35px">Features</h2>
			<div class="row justify-content-center">
				<div class="col-md-6">
					<p class="lead">Pluck system focuses on the project and task
						. It has different user roles to manage people and
						projects. Super Admin, Company Admin, Project Lead, Project Manager, Scrum Master, Project User All
						of these users have different level of access to manage Teams,
						Projects, Tasks and Test Suites.</p>
				</div>
			</div>
		</div>

		<div class="row"
			style="margin-top: 40px; width: 80%; margin-left: 160px">

			<div class="col-lg-4 col-md-4">
				<div class="mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3 ">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Super Admin</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Super Admin has
							the highest level of access. He can manage all companies along
							with their activities. Major role of Super Admin is to perform
							CRUD operations for company and Company Admin. Super Admin can
							add multiple companies and a company can have multiple admins.</p>
					</div>
				</div>
			</div>
			<div class="col-lg-4 col-md-4">
				<div class="mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3 ">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Company Admin</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Company Admin
							works on the project management. He can perform CRUD operations
							for the projects and Project Owners. Company admin can add
							multiple projects and a project can have multiple Project Owners.
							Admin can do everything which a Project Owner and User can do.</p>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-4">
				<div class=" mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Project Lead</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Project Lead has
							to manage the project related tasks and the users under them. A
							project Lead can have multiple users under them who can be
							developers or QA.</p>
					</div>
				</div>
			</div>
		</div>
		
		<div class="row"
			style="width: 80%; margin-left: 160px">
			
			<div class="col-lg-4 col-md-4">
				<div class=" mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Project Manager</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Project Manager, he should be able to Add Scrum Team for any project.
						Project Manager only have authority to change  lower roles like project lead, scrum master, project user. Not for high roles like super admin and company admin. </p>
					</div>
				</div>
			</div>
			<div class="col-lg-4 col-md-4">
				<div class=" mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Scrum Master</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Scrum master can update own status and lower role like Project user.
						Scrum Master, User should be able to See Dashboard for any project.In Scrum Master, User only See All user of selected project. 
						As a Scrum Master, User is able to see all project which ever project assigned to Scrum master. </p>
					</div>
				</div>
			</div>
			<div class="col-lg-4 col-md-4">
				<div class=" mb-4 text-center ftco-media p-md-4"
					style="border: 1px solid">
					<div style="margin-top: -10px" class="ftco-icon mb-3">
						<span class="oi oi-person display-4 text-muted"></span>
					</div>
					<div class="media-body" style="height: 275px">
						<h5 class="mt-0">Project User</h5>
						<p class="mb-5 mt-4" style="font-size: 14px">Project users as
							developer or QA have the lowest level of access in Pluck system
							to perform functionality related to project. They can only work
							on the tasks.</p>
					</div>
				</div>
			</div>
		</div>

	</section>


	<section class="ftco-section bg-light  ftco-slant ftco-slant-white"
		id="section-pricing">

		<div class="row">
			<div class="col-md-12  text-center mb-5">
				<h2 class="text-uppercase ftco-uppercase heading"
					style="color: #000094; font-size: 35px">Pricing</h2>
				<div class="row justify-content-center mb-5">
					<div class="col-md-6">
						<p class="lead">Far far away, behind the word mountains, far
							from the countries Vokalia and Consonantia, there live the blind
							texts.</p>
					</div>
				</div>
			</div>
		</div>
		<div class='row' style="margin: 0px 0px 0px 250px">
			<div class="col-md-3 bg-white p-5 m-2 text-center mb-2 "
				style="border: 1px solid">
				<div class="ftco-pricing">
					<h2 class="heading">Basic</h2>
					<p class="ftco-price-per text-center">
						<sup>$</sup><strong class="text-primary">25</strong><span>/mo</span>
					</p>
					<ul class="list-unstyled mb-5">
						<li>Far far away behind the word mountains</li>
						<li>Even the all-powerful Pointing has no control</li>
						<li>When she reached the first hills</li>
					</ul>
					<p>
						<a href="#" class="btn btn-primary btn-sm">Get Started</a>
					</p>
				</div>
			</div>
			<div class="col-md-3 bg-white p-5 m-2 text-center mb-2"
				style="border: 1px solid">
				<div class="ftco-pricing">
					<h2 class="heading">Advanced</h2>
					<p class="ftco-price-per text-center">
						<sup>$</sup><strong>75</strong><span>/mo</span>
					</p>
					<ul class="list-unstyled mb-5">
						<li>Far far away behind the word mountains</li>
						<li>Even the all-powerful Pointing has no control</li>
						<li>When she reached the first hills</li>
					</ul>
					<p>
						<a href="#" class="btn btn-primary btn-sm">Get Started</a>
					</p>
				</div>
			</div>

			<div class="w-100 clearfix d-xl-none"></div>
			<div
				class="col-md-3 bg-white  ftco-pricing-popular p-5 m-2 text-center mb-2"
				style="border: 1px solid">
				<div class="ftco-pricing">
					<h2 class="heading">Ultimate</h2>
					<p class="ftco-price-per text-center">
						<sup>$</sup><strong class="text-primary">135</strong><span>/mo</span>
					</p>
					<ul class="list-unstyled mb-5">
						<li>Far far away behind the word mountains</li>
						<li>Even the all-powerful Pointing has no control</li>
						<li>When she reached the first hills</li>
					</ul>
					<p>
						<a href="#" class="btn btn-primary btn-sm">Get Started</a>
					</p>
				</div>
			</div>
		</div>
	</section>

	<section class="ftco-section bg-light  ftco-slant ftco-slant-white"
		id="section-about">

		<div class="row mt-4">
			<div class="col-md-12  text-center mb-5">
				<h2 class="text-uppercase ftco-uppercase heading"
					style="color: #000094; font-size: 35px">About Us</h2>
				<div class="row justify-content-center mb-5">
					<div class="col-md-7">
						<p class="lead">
							Pluck is a project management system which manages all the
							different resources and aspects of the project in such a way that
							the resources will deliver all the output that is required to
							complete the project within the defined scope and time. The test
							suite module of the application allows users to configure and run
							automatic test cases that report the test execution status.<a
								href="http://veracity-india.com" target="_blank">admin@veracity-india.com</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="row no-gutters align-items-center"
			style="width: 80%,; margin: auto;">
			<div class="col-md-6 mb-md-0 mb-5">
				<img style="width: 88%; height: 300px"
					src="${pageContext.request.contextPath}/images/Bug_Tracking.png"
					alt="Bug Tracking" class="img-fluid" />
			</div>
			<div class="col-md-6 p-md-5">
				<h3 class="h3 mt-0 mb-4 heading">Bug Tracking</h3>
				<p>Testing teams use bug tracking to monitor and report on
					errors that occur as an application is developed and tested.It may
					include the time a bug was reported, its severity, the erroneous
					program behavior and details on how to reproduce the bug; as well
					as the identity of the person who reported it and any programmers
					who may be fixing it.Bugs are managed based on priority and
					severity. Severity levels help to identify the relative impact of a
					problem on a product release.</p>

			</div>
		</div>

		<div class="row no-gutters align-items-center mt-1"
			style="width: 80%,; margin: auto;">
			<div class="col-md-6 mb-md-0 mb-5">
				<img style="width: 88%; height: 300px"
					src="${pageContext.request.contextPath}/images/taskmanagement.jpg"
					alt="Task Management" class="img-fluid" />
			</div>
			<div class="col-md-6 p-md-5">
				<h3 class="h3 mt-0 mb-4 heading">Task Management</h3>
				<p>Tracking tasks from beginning to end, delegating subtasks to
					teammates, and setting deadlines to make sure projects get done on
					time. Check in on the status of your teams projects at a glance.
					Easily see status changes and updates on individual tasks. Easily
					assign tasks to team members. Set due dates for larger projects.</p>
			</div>
		</div>


		<div class="row no-gutters align-items-center mt-2"
			style="width: 80%,; margin: auto;">
			<div class="col-md-6 mb-md-0 mb-5">
				<img style="width: 88%; height: 300px"
					src="${pageContext.request.contextPath}/images/usermanagement.jpg"
					alt="UserManagement" class="img-fluid" />
			</div>
			<div class="col-md-6 p-md-5">
				<h3 class="h3 mt-0 mb-4 heading">User Management</h3>
				<p>Helps to manage users and roles defined in the Pluck. You
					must be logged in as a member of the Administrators to add, delete,
					or modify a user or role. In role-based authorization, security
					policies define the roles that are authorized to access the
					resource.</p>
			</div>
		</div>

		<div class="row no-gutters align-items-center mt-1"
			style="width: 80%,; margin: auto;">
			<div class="col-md-6 mb-md-0 mb-5">
				<img style="width: 88%; height: 300px"
					src="${pageContext.request.contextPath}/images/projectmanagement.png"
					alt="UserManagement" class="img-fluid" />
			</div>
			<div class="col-md-6 p-md-5">
				<h3 class="h3 mt-0 mb-4 heading">Project Management</h3>
				<p>Project management is the process by which a project is
					planned, tracked, controlled, and reported. Each project has a
					specific start date and end date. In addition, a project produces a
					specific deliverable. Proven project management processes help move
					a project towards completion. These include: Planning & scheduling,
					Resource management, Risk management, Task management & monitoring,
					Reporting. Project Owners are responsible for planning and
					executing a project along with the project team to produce the
					desired deliverable and meet stakeholder expectations.</p>
			</div>
		</div>

	</section>


		<section id="section-contact" class="ftco-section bg-light  ftco-slant ftco-slant-white mt-4" style="margin: auto;">

						<div class="row">
							<div class="col-md-12  text-center mb-5">
								<h2 class="text-uppercase ftco-uppercase heading"  style="color: #000094; font-size: 35px">Get In Touch</h2>
								<div class="row justify-content-center mb-5">
									<div class="col-md-7">
										<p class="lead">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Feel free to send us an email to.</p></div>
								</div>
							</div>
						</div>
						<div class="col-md-12" >
							<div class="row" style="margin: 0px 0px 0px 80px">
								<div class="col-md-6 wow fadeInUp" style="padding: 10px">
									<div class="block ">
										<div class="sub-heading">
											<h4> Address</h4>
										</div>
										<address class="address">
											<hr />
											<p>Office No. 501,<br />  5th floor,<br /> Pentagon P4</p>
											<hr />
											<p><strong>Magarpatta City,</strong>&nbsp;Hadapsar,<br />
												<strong>Pune - 411028</strong>&nbsp;</p>
											<hr />
											<i style="color: #2a77b7; font-size: 25px"></i><strong>PHONE:</strong>  +91
											<hr />
											<i style="olor: #2a77b7; font-size: 25px"></i><strong>EMAIL:</strong> contact@veracity-us.com
										</address>
									</div>
								</div>
								<div class="col-md-6 col-md-offset-1  wow fadeInUp" data-wow-delay="0.3s" style="padding: 10px">
									<h4> Contact</h4>
									<div class="form-group">
										<form action="#" method="post" id="contact-form">
											<div class="input-field" style="box-sizing: border-box;">
												<input type="text" class="form-control" placeholder="Your Name" name="name" />
											</div>
											<div class="input-field">
												<input type="email" class="form-control" placeholder="Email Address" name="email" />
											</div>
											<div class="input-field">
												<textarea class="form-control" placeholder="Your Message" rows={ 10 } name="message" defaultValue={ "" } ></textarea>
											</div>
											<button class="btn btn-send btn-success" type="submit" style="padding: 10px; font-size: 15px; width: 100%">SUBMIT</button>
										</form>
										
									</div>
								</div>
							</div>
						</div>


					</section>



	


	<footer>
		<div id="footer-name" >
			<h4>Veracity Software Pvt. Ltd. 2023</h4>
			<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
			<div id="footer-social-icon">
				<i class="fa-brands fa-instagram"></i> <i
					class="fa-brands fa-twitter"></i> <i class="fa-brands fa-linkedin"></i>
				<i class="fa-brands fa-facebook"></i>
			</div>
		</div>
		<div class="footer-link">
			<h4>ABOUT US</h4>
			<div>
				<a href="#">Works</a> <a href="#">Strotragy</a> <a href="#">Release</a>
				<a href="#">Press</a> <a href="#">mission</a>
			</div>
		</div>
		<div class="footer-link">
			<h4>CUSTOMERS</h4>
			<div>
				<a href="#">Tranding</a> <a href="#">Popular</a> <a href="#">Customers</a>
				<a href="#">Features</a>
			</div>
		</div>
		<div class="footer-link">
			<h4>SUPPORT</h4>
			<div>
				<a href="#">Developer</a> <a href="#">Support</a> <a href="#">Customer
					Service</a> <a href="#">Get started</a> <a href="#">Guide</a>
			</div>
		</div>
	</footer>

</body>

</html>