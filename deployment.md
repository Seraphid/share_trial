# CI/CD Pipeline
## Git Distribution
For the Continuous integration solution, I would add a git repository for the team to work collaboratively in the project. I propose **Gitlab**, since it is straightforward to use and implement de CI/CD pipeline for managing the source code and assuring everything runs correctly.

In the Git repository, I propose three kinds of branches:
- **Main**: This is the release where we will train the models for cloud deployment. We will periodically merge the **develop** branch into **Main**, scheduling releases.
- **Develop**: This is the branch where we will be merging the new features and fixes for the code base. We won't work in this branch as it is. We will only merge **Feature** branches into **Develop** once features are finished.
- **Feature branches**: For each feature, we will assign a diferent branch for each feature. Once complete, we will merge the branch into develop

We will create integration tests and unitary tests for our library, where we will be testing primarily the preprocessing of the data and the output of our models working correctly. The tests for the new feature should be finished before merging the **Feature** branch into **Develop**
## CI/CD Configuration
For the configuration, we will create a configuration file, where we will configure the stages and the corresponding jobs for our pipeline. In our case, we will need two stages, **build** and **test**. Let's start by defining the **test** job.

The **test** job should run all the integration and unit tests for our application. I recommend we run it every time a merge is made to **Main** or **Develop** branch. If any test fails after merging the branches, we won't commit the result to the repository until it is fixed. Although it may seem like a good idea, I don't recommend applying the same concept to the **Feature** branches, since it will make more difficult to share the code to a colleague for solving a concrete problem.

After configuring the pipeline, we will need some workers to run the jobs each time a **merge** is done in **Main** or **Develop** branch. We can configure them locally if we host the **Gitlab** repository ourselves or use their runners service for this task. I would recommend using their runners since its a better solution in the long run in terms of scalability and ease of use.

# Deployment and metric tracking
For this purpose we'll be using **MLFlow**, since it satisfies all of our needs for this project.
## Metric tracking
We would configure **MLFlow** for tracking all the metrics we found interesting for our problem. In this case, I think **accuracy**, **micro** and **macro** **precision**, **recall**, **f1 score** and **loss** are the most interesting ones to save, although depending on the needs of the client we could use other ones. We will also store the models we train as artifacts with their metrics, for the posterior development.

Using **MLFlow** we can take a look at all of the models we registered, and we can sort them by different metrics. If there's no special requisite, I would order them by **loss** for this specific problem.
## Model deployment
Once we have selected our desired model by checking the metrics, we can finally deploy our model. The first step would be to create a **docker** container for our model, where it will be listening for the input of the inference data in a certain port. We can do this with a **MLFlow** CLI utility, called **build-docker**. Once we have our **docker** image, we can serve it locally or in a cloud environment. I would recommend using a cloud solution for the sake of scalability and ease of use, like **Amazon SageMaker** or **Azure ML**.
