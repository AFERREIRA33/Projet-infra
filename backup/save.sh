#!/bin/bash

log_date=$(date +"[%y/%m/%d %H:%M:%S]")
file_date=$(date +"%y%m%d_%H%M%S")
backup_path="/srv/backup"
archive_path="${backup_path}/mc_${file_date}"
file_path="${backup_path}/mc"
log_path="/var/log/backup"
log_file="${log_path}/backup.log"
server="serv_install@10.200.1.5:/Minecraft"
line="Backup ${archive_path} created successfully."
line_error="[ ERROR ] Backup ${archive_path} was not created!"

if [ -d "$backup_path" ]
then
        echo "already exist"
else
        mkdir "$backup_path"
fi

if [ -f "${file_path}" ]
then
        echo "already exist"
else
        mkdir "${file_path}"
fi

rsync -av --delete -e "${server}" "${file_path}"
tar -cvzf "${archive_path}".tar.gz "${file_path}"
rm -rf "${file_path}"
if [ -d "${log_path}" ]
then
        mkdir "${log_path}"
fi

if [ -f "${log_file}" ]
then
                sudo touch "${log_file}"
fi
if [ -f "${archive_path}" ]
then
        echo "${log_date} ${line}" >> "${log_file}"
        echo "${line}"
else
        echo "${log_date} ${line_error}" >> "${log_file}"
        echo "${line_error}"
fi