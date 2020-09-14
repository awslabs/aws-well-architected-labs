#!/usr/bin/ruby 

files = `ls -1 *.md`.gsub(/\.md/, '').downcase.split(/\n/) 

print "\n\n" 
print "{{< prev_next_button link_next_url=\"./#{files[0]}/\" button_next_text=\"Start Lab\" first_step=\"true\" />}}\n" 

print "{{< prev_next_button link_prev_url=\"../\" link_next_url=\"../#{files[1]}/\" />}}\n" 

counter = 2 

while counter < files.count-1 do 

    print "{{< prev_next_button link_prev_url=\"../#{files[counter-2]}/\" link_next_url=\"../#{files[counter]}/\" />}}\n" 

    counter = counter + 1 
end 

print "{{< prev_next_button link_prev_url=\"../#{files[counter-2]}/\"  title=\"Congratulations!\" final_step=\"true\" >}}\n" 
print "Now that you have completed the lab, if you have implemented this knowledge in your environment, \n" 
print "you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with \n"
print "[COST1 - \"Understand the available compute configuration options.\"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-selection.html)\n" 
print "{{< /prev_next_button >}}\n" 

print "\n\n" 

