import java.awt.Robot;
import java.awt.event.*;
robot = java.awt.Robot;

load ('members.mat');%'members.mat'->members
num = length(members);
members = zeros(num);
whitelist = [ 3 , 19 , 29 ];        %���ð�����
hello_yes = '���Ͽ���';     %��ϯ��ʾ��
hello_no = 'û��!';         %ȱϯ��ʾ��
pause(7);                  %�ȴ��ֶ����ý���

fprintf ('ͳ�ƿ�ʼ;%s\n',datetime);
for n = 1 : num
    
    for m = 1 : length(whitelist)
        if n == whitelist(m)
            continue_ = 1;
            break;
        else
            continue_ = 0;
        end
    end
    if continue_ == 1
        continue;
    end
    
    robot.mouseMove(55,160);
    robot.mousePress(InputEvent.BUTTON1_MASK);
    pause(0.1);
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    
    clipboard('copy',cell2mat(members(n)));
    robot.keyPress    (java.awt.event.KeyEvent.VK_CONTROL);%��סCtrl
    robot.keyPress    (java.awt.event.KeyEvent.VK_A);      %��סa
    robot.keyRelease  (java.awt.event.KeyEvent.VK_A);      %�ɿ�a
    robot.keyPress    (java.awt.event.KeyEvent.VK_V);      %��סv
    robot.keyRelease  (java.awt.event.KeyEvent.VK_V);      %�ɿ�v
    robot.keyRelease  (java.awt.event.KeyEvent.VK_CONTROL);%�ɿ�Crtl
    robot.keyPress    (java.awt.event.KeyEvent.VK_ENTER);  %��ס�س���
    pause(0.1);
    robot.keyRelease  (java.awt.event.KeyEvent.VK_ENTER);  %�ɿ��س���
    pause(0.1);
    
    t = java.awt.Toolkit.getDefaultToolkit();
    rec = java.awt.Rectangle(t.getScreenSize());
    image = robot.createScreenCapture(rec);
    filehandle = java.io.File('image.png');
    javax.imageio.ImageIO.write(image,'png',filehandle);
    screen = imread('image.png');
    
    if min( [ screen(184,137,:) , screen(183,137,:) , screen(185,137,:) ] )<200
        members_(n) = 1;
        fprintf ('<%d> %s %s \n', n , cell2mat(members(n)) , hello_yes );
    else
        members_(n) = 0;
        fprintf ('<%d> %s %s \n', n , cell2mat(members(n)) , hello_no );
    end
    pause(0.1);
end
fprintf ('ͳ�ƽ���;%s\n',datetime);
fprintf ('���ڣ�%d��,δ���ڣ�%d�ˣ���������%d�ˡ�\n', sum(members_) , length(members)-sum(members_)-length(whitelist) , length(whitelist) );