# YOGLOOP
YOGLOOP is a software for identifying short-range chromatin loops.    
#Install    

git clone <repository-url>  
  conda create -n YOGLOOP  
  conda install python=3.1  
  pip install ultralytics==8.3.51  

#Usage

1. Data Format Preparation
YOGLOOP requires 6-column BEDPE files, with each chromosome stored as a separate file in the yo_out directory. We provide a script to convert HiC-Pro's allValidPairs into BEDPE format.  
sh ~/yogloop/bin/yogloop_pre.sh -i A01.allValidPairs -g A01.fai

2. Generate Background Interaction Matrix
This background matrix is used for subsequent normalization of interaction matrices. Note that the background matrix size must match the matrices generated in later steps.  
sh ~/yogloop/bin/yogloop_bg.sh -d ./yo_out/ -g A01.fai -t 10
<img width="226" height="226" alt="image" src="https://github.com/user-attachments/assets/bf09e669-1b90-4acc-88f1-761553535563" />

3. Generate Heatmaps Centered on Each Gene
Results are saved in the plot_results directory. Each image is named by the gene’s chromosome and left coordinate (e.g., A01_1494025.jpg).  
sh ~/yogloop/bin/yogloop_plot.sh -d yo_out/ -g A01.gff -b 20000_background.txt -t 20

4. Predict Genome-Wide Loops  
sh ~/yogloop/bin/yogloop_detect.sh -m ~/yogloop/model/best.pt -c ~/yogloop/model/classes.txt -i plot_results/A01  
Loop results are saved in raw_loop.bedpe.  
For manual data annotation and model training, refer to the [Ultralytics YOLO Documentation](https://docs.ultralytics.com/zh/).

5. Predict Loops for a Single Gene  
yolo predict source=A01_1046.jpg model=~/yogloop/model/best.pt save=True

6. Generate Single Heatmap with YOGLOOP  
This script supports three modes: standard heatmap, Gaussian-smoothed enhanced heatmap, and distance-corrected heatmap.  
sh ~/yogloop/scripts/yogloop_view.sh -i yo_out -c A01 -s 100000 -e 120000 -m gaussian  
<img width="246" height="246" alt="image" src="https://github.com/user-attachments/assets/b2a7c76a-b6af-48a4-a1e2-afbaa7ca3379" />

7. Generate Loop Enrichment Heatmap (APA Plot)  
sh ~/yogloop/scripts/yogloop_APA.sh -l raw_loop.bedpe -f yo_out/A01.bedpe -o APA_plot  

8. Generate Mini-Loop Enrichment Heatmap  
sh ~/yogloop/scripts/yogloop_strip.sh -l miniloop.bed -f yo_out -t 10  
