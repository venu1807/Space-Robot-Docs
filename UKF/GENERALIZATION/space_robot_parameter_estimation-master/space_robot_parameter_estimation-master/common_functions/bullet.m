function bullet_matrix = bullet(omg)
    bullet_matrix = [omg(1) 0 0 omg(2) 0 omg(3); ...
                       0 omg(2) 0 omg(1) omg(3) 0; ...
                       0 0 omg(3) 0 omg(2) omg(1)];
end