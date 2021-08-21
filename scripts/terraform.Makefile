# SPDX-License-Identifier: copyleft-next-0.3.1
#
KDEVOPS_BRING_UP_DEPS := bringup_terraform
KDEVOPS_DESTROY_DEPS := destroy_terraform

export KDEVOPS_CLOUD_PROVIDER=aws
ifeq (y,$(CONFIG_TERRAFORM_AWS))
endif
ifeq (y,$(CONFIG_TERRAFORM_GCE))
export KDEVOPS_CLOUD_PROVIDER=gce
endif
ifeq (y,$(CONFIG_TERRAFORM_AZURE))
export KDEVOPS_CLOUD_PROVIDER=azure
endif
ifeq (y,$(CONFIG_TERRAFORM_OPENSTACK))
export KDEVOPS_CLOUD_PROVIDER=openstack
endif

TFVARS_TEMPLATE_DIR=terraform/templates
TFVARS_FILE_NAME=terraform.tfvars
TFVARS_FILE_POSTFIX=$(TFVARS_FILE_NAME).in

KDEVOPS_TFVARS_TEMPLATE=$(TFVARS_TEMPLATE_DIR)/$(KDEVOPS_CLOUD_PROVIDER)/$(TFVARS_FILE_POSTFIX)
KDEVOPS_TFVARS=terraform/$(KDEVOPS_CLOUD_PROVIDER)/$(TFVARS_FILE_NAME)
ifeq (y,$(CONFIG_TERRAFORM_AWS))
KDEVOS_TERRAFORM_EXTRA_DEPS += $(KDEVOPS_TFVARS)
endif

ifeq (y,$(CONFIG_TERRAFORM_AZURE))
KDEVOS_TERRAFORM_EXTRA_DEPS += $(KDEVOPS_TFVARS)
endif

ifeq (y,$(CONFIG_TERRAFORM_GCE))
KDEVOS_TERRAFORM_EXTRA_DEPS += $(KDEVOPS_TFVARS)
endif

ifeq (y,$(CONFIG_TERRAFORM_OPENSTACK))
KDEVOS_TERRAFORM_EXTRA_DEPS += $(KDEVOPS_TFVARS)
endif

SSH_CONFIG_USER:=$(subst ",,$(CONFIG_TERRAFORM_SSH_CONFIG_USER))
# XXX: add support to auto-infer in devconfig role as we did with the bootlinux
# role. Then we can re-use the same infer_uid_and_group=True variable and
# we could then remove this entry.
ANSIBLE_EXTRA_ARGS += data_home_dir=/home/${SSH_CONFIG_USER}

bringup_terraform:
	$(Q)$(TOPDIR)/scripts/bringup_terraform.sh

destroy_terraform:
	$(Q)$(TOPDIR)/scripts/destroy_terraform.sh

