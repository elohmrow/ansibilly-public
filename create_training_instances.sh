#!/bin/bash

# simple wrapper script for running an ansible playbook
# first pass.  could of course be more generic.  this was like 1 hour of work.

# before we do anything, check that we have ansible installed on this machine:
if [ ! -x /usr/local/bin/ansible-playbook ]; then
    echo "Hrm ... you don't seem to have ansible installed.  You are the weakest link - goodbye."
    
    exit 1;
fi

TEST=${1:-false}
temp_vault_pass_file=temp_vault_pass_file.txt
num_beers=1

function clean_up {
    # clean up the files you generated:
    if [ "$TEST" = false ] ; then
        rm -f provision_author*.yml
        rm -f hosts
        rm -f vars.yml
        rm -f temp_vault_pass_file.txt
        rm -rf keys
    fi
}

function alles_gute {
    echo ""
    echo "========================================================"
    echo "All done.  You owe Bradley $num_beers beer(s).          "
    echo "========================================================"
    echo ""

    clean_up;

    exit 0;
}

clean_up;   # just in case something was left over

echo ""
echo "========================================================"
echo "This script will create some Magnolia instances for you."
echo "========================================================"
echo ""

echo "Please tell me how many instances you need (this is usually the number of training participants):" 
read num_instances
echo ""
num_beers=$num_instances

echo "Where is your vault file?"
read key_file_loc
echo ""
# check that the key file exists:
if [ ! -f $key_file_loc ]; then
    echo "Hrm ... I can't find that key file.  Please try again!"

    alles_gute;
fi

echo "Where is your keypair?"
read key_pair_loc
# check that the keypair exists:
if [ ! -f $key_pair_loc ]; then
    echo "Hrm ... I can't find that keypair.  Please try again!"

    alles_gute;
fi
mkdir -p keys
cp -f $key_pair_loc keys
# only keep the name of the key
key=${key_pair_loc##*/}

echo ""
echo "Please enter your vault password:" 
read -s vault_pass  # the '-s' is for masking user input, since this is a password
# create a temporary file for this to avoid prompting later:
rm -f $temp_vault_pass_file     # kill the file if it already exists
echo "$vault_pass" >> $temp_vault_pass_file
echo ""

####
# commence with the handwaving ...
# now create everything we need on the fly, so the user doesn't have to worry about any of it.
cat <<EOT >> provision_authors.yml
  - name: Provision an EC2 instance(s) for Magnolia author instance(s)
    hosts: authors
    connection: local
    gather_facts: False
    tags: provisioning

    # Encrypted variables for AWS access
    vars_files:
      - $key_file_loc

    # Tasks to create EC2 instance given an established AMI
    tasks:
      - name: include variables
        include_vars: vars.yml
      - include: provision_author.yml
EOT

cat <<EOT >> vars.yml
security_groups: ['public-dynamic', 'launch-wizard-1']
instance_type: t2.medium                                
image: ami-846e4ce1                                     
wait: yes                                               
region: us-east-2                                       
keypair: ${key%%.*}                             
count: $num_instances                                                
vpc_subnet_id: subnet-be6afdd7                          
assign_public_ip: yes                                   
EOT

cat <<EOT >> provision_author.yml
- name: Launch a new EC2 instance for Magnolia
  local_action: ec2
                aws_access_key={{ magnolia_aws_access_key }}
                aws_secret_key={{ magnolia_aws_secret_key }}
                groups={{ security_groups }}
                instance_type={{ instance_type }}
                image={{ image }}
                wait={{ wait }}
                region={{ region }}
                keypair={{ keypair }}
                count={{ count }}
                vpc_subnet_id={{ vpc_subnet_id }}
                assign_public_ip={{ assign_public_ip }}
  register: ec2
EOT

cat <<EOT >> ./hosts
[authors]
localhost
EOT

if [ "$TEST" != false ] ; then
    # for testing:
    echo ""
    echo "you provided the following variables: "
    echo "number of trainees: $num_instances"
    echo "keypair: $key_pair_loc"
    echo "key file location: $key_file_loc"
    echo "vault pass: $vault_pass"
    echo ""

    echo ""
    echo "here is the command i will run: "
    echo "ansible-playbook provision_authors.yml -i hosts --vault-password-file $temp_vault_pass_file"
    echo ""
fi

# actually run the command:
ansible-playbook provision_authors.yml -i hosts --vault-password-file $temp_vault_pass_file 

alles_gute;
