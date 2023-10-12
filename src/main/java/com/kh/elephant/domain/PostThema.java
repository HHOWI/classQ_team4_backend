package com.kh.elephant.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class PostThema {

    @Id
    @Column(name = "post_thema_seq")
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "postThemaSequence")
    @SequenceGenerator(name="postThemaSequence", sequenceName = "SEQ_POST_THEMA", allocationSize = 1)
    private int postThemaSeq;

    @Column(name="pt_name")
    private String ptName;

    @ManyToOne
    @JoinColumn(name = "board_seq")
    private Board board;

}
