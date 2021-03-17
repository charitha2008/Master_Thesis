% For extracting MLO views from folders and copying in different folders
% Specify folder names accordingly
Dest_Normal    = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/New_Images/Normal';
Dest_Cancer     = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/New_Images/Cancer';
Dest_Benign     = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/New_Images/Benign';
Folder_Normal = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/Normal';
Folder_Cancer = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/Cancer';
Folder_Benign = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/Benign';
FileList_Normal = dir(fullfile(Folder_Normal, '*.png'));
FileList_Cancer = dir(fullfile(Folder_Cancer, '*.png'));
FileList_Benign = dir(fullfile(Folder_Benign, '*.png'));

for k = 1:length(FileList_Normal)
    Source_Normal = fullfile(Folder_Normal, FileList_Normal(k).name);
    pattern = "CC";
    TF = contains(FileList_Normal(k).name,pattern);
    if TF==0
        copyfile(Source_Normal, Dest_Normal);
    end
end
for k1 = 1:length(FileList_Cancer)
    
    Source_Cancer = fullfile(Folder_Cancer, FileList_Cancer(k1).name);  
    pattern = "CC";
    TF1 = contains(FileList_Cancer(k1).name,pattern);
    if TF1==0
        copyfile(Source_Cancer, Dest_Cancer);
    end
end
for k2 = 1:length(FileList_Benign)
    Source_Benign = fullfile(Folder_Benign, FileList_Benign(k2).name);
    pattern = "CC";
    TF2 = contains(FileList_Benign(k2).name,pattern);
    if TF2==0
        copyfile(Source_Benign, Dest_Benign);
    end
end