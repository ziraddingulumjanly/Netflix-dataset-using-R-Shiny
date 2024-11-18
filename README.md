# Netflix-dataset-using-R-Shiny

This Netflix Titles Dashboard is an interactive tool for navigating the Netflix dataset and analyzing content trends and patterns. Users may choose by content type (movies or TV shows), release year range, genres, and runtime, and examine insights through three dynamic plots.

![image](https://github.com/user-attachments/assets/386fcf21-5655-41bf-9ba0-9428f60f66da)

Dataset: 🔗 Bansal, S. (2019). Netflix shows and movies - Exploratory analysis [Dataset]. Kaggle. Retrieved from https://www.kaggle.com/code/shivamb/netflix-shows-and-movies-exploratory-analysis/input

REPORT:
Interactive Visualization
The Shiny app offers three distinct interactive visualizations that let people study Netflix title data. The first plot, Release Trends, utilizes a bar chart to show the number of Netflix titles published each year, divided by kind (movie or TV show). The second plot, Genre Distribution, depicts the frequency of different genres, allowing viewers to determine the most and least prevalent genres in Netflix content. The final figure, Duration Analysis, displays a histogram that depicts the distribution of content durations, assisting viewers in understanding the average length of Netflix titles.
User Inputs
The app has four interactive input choices to let users engage and explore. A dropdown menu allows users to filter the dataset by content type, distinguishing between movies and television shows. A slider widget lets the user choose a range of release years for examination. A checkbox category also allows users to select certain genres of interest, allowing for more concentrated investigation of genre-based patterns. Finally, a duration slider filters titles based on their runtime, allowing user preferences for longer or shorter material.
Data and Code Portability
The program is designed to run seamlessly on any PC with RStudio and the essential libraries installed. The read.csv method references to the dataset via a relative path, allowing compatibility regardless of the local file system. The code avoids the need of setwd(), making the application more portable and applicable in a number of settings.

Ziraddin Gulumjanli, 2024 November.

