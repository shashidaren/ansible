- name: Apply security updates on RHWL systems 
  shell: dnf update --security -y 
  register: update_result 
  when: ansible_os_family == "Redhat"

- name: check if reboot is required 
  shell: needs-restarting -r || echo "no-reboot" 
  register: reboot check 
  changed_when: false
  when: ansible_os_family == "Redhat"

- name: Reboot system if required
  reboot: 
    msg: "Reboot triggered by Ansible after security updates"
    pre_reboot_delay: 5 
  when:
    - apply_reboot_if_kernel_updated
    - reboot_check.stdout != "no-reboot"
