# Terraform - Multi Region Nginx Setup

This repo contains Terraform configuration files to deploy Nginx in two AWS regions.

## Files
- main.tf - Main resources
- variables.tf - Input variables
- outputs.tf - Outputs

## Purpose
- Deploy EC2 instances in East and South regions
- Install and start Nginx on both
- Access Nginx welcome page via public IP
