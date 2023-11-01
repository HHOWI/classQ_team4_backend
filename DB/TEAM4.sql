-- 테이블 삭제
DROP TABLE USER_INFO CASCADE CONSTRAINT;   -- 유저 정보 
DROP TABLE BLOCK_USERS CASCADE CONSTRAINT;     -- 차단 유저
DROP TABLE USER_LIKE CASCADE CONSTRAINT;       -- 유저 좋아요
DROP TABLE POST CASCADE CONSTRAINT; -- 게시글 TABLE DROP
DROP TABLE POST_ATTACHMENTS CASCADE CONSTRAINT; -- 게시글첨부파일정보 TABLE DROP
DROP TABLE BOARD CASCADE CONSTRAINT; -- 게시판 TABLE  DROP
DROP TABLE MATCHING_USER_INFO CASCADE CONSTRAINT;   -- 매칭 참여 유저 정보
DROP TABLE COMMENT_LIKE CASCADE CONSTRAINT; -- 댓글좋아요
DROP TABLE CATEGORY CASCADE CONSTRAINT;     -- 카테고리
DROP TABLE COMMENTS CASCADE CONSTRAINT;     -- 댓글
DROP TABLE CATEGORY_TYPE CASCADE CONSTRAINT; -- 카테고리(관심사)분류
DROP TABLE PLACE CASCADE CONSTRAINT;        -- 지역
DROP TABLE PLACE_TYPE CASCADE CONSTRAINT;   -- 지역 분류
DROP TABLE USER_CATEGORY_INFO CASCADE CONSTRAINT;   -- 유저 관심사 정보
DROP TABLE MATCHING_CATEGORY_INFO CASCADE CONSTRAINT;   -- 매칭글 관심사 정보
DROP TABLE USER_CHATROOM_INFO CASCADE CONSTRAINT;
DROP TABLE CHATMESSAGE CASCADE CONSTRAINT;
DROP TABLE CHATROOM CASCADE CONSTRAINT;


-- 시퀀스 삭제
DROP SEQUENCE SEQ_BLOCK_USER; -- 유저 차단 SEQ
DROP SEQUENCE SEQ_BOARD; -- 게시판 SEQUENCE
DROP SEQUENCE SEQ_CATEGORY;             -- 카테고리 SEQ
DROP SEQUENCE SEQ_CATEGORY_TYPE;         -- 카테고리(관심사)분류 SEQ
DROP SEQUENCE SEQ_COMMENT_LIKE;         -- 댓글 좋아요 SEQ
DROP SEQUENCE SEQ_COMMENTS;             -- 댓글 SEQ
DROP SEQUENCE SEQ_MATCHING_USER_INFO;             -- 매칭유저정보 SEQ
DROP SEQUENCE SEQ_PLACE;      -- 유저 정보 테이블
DROP SEQUENCE SEQ_PLACE_TYPE;             -- 지역분류 SEQ
DROP SEQUENCE SEQ_POST; -- 게시글 SEQUENCE
DROP SEQUENCE SEQ_POST_ATTACHMENT; -- 게시글 첨부 파일 정보 SEQUENCE
DROP SEQUENCE SEQ_USER_LIKE; -- 유저 좋아요 SEQ
DROP SEQUENCE SEQ_USER_CATEGORY_INFO; -- 유저 관심사 정보 SEQ
DROP SEQUENCE SEQ_MATCHING_CATEGORY_INFO; -- 매칭글 관심사 정보 SEQ
DROP SEQUENCE SEQ_USER_CHATROOM_INFO;
DROP SEQUENCE SEQ_CHATMESSAGE;
DROP SEQUENCE SEQ_CHATROOM;

CREATE TABLE USER_INFO(
    USER_ID VARCHAR2(50) PRIMARY KEY,       -- 유저 아이디
    USER_PWD VARCHAR2(150) NOT NULL,     -- 유저 패스워드
    USER_NAME VARCHAR2(30) NOT NULL,        -- 유저 이름
    USER_NICKNAME VARCHAR2(50) UNIQUE NOT NULL,     -- 유저 닉네임
    AGE NUMBER,     -- 나이
    GENDER VARCHAR2(10)  CHECK(GENDER IN ('남', '여', NULL)),       -- 성별
    PLACE_TYPE_SEQ NUMBER DEFAULT 0,       -- 활동지역
    PHONE VARCHAR2(20) NOT NULL UNIQUE,        -- 전화번호
    EMAIL VARCHAR2(50) NOT NULL UNIQUE, -- 이메일
    PROFILE_IMG VARCHAR2(500),      -- 프로필 이미지
    STATUS_MESSAGE VARCHAR2(1000),      -- 상태 메세지
    HAS_PARTNER VARCHAR2(1) CHECK(HAS_PARTNER IN ('Y', 'N')),      -- 애인 유무
    BLOOD_TYPE VARCHAR2(5) CHECK(BLOOD_TYPE IN ('A', 'B', 'AB', 'O')),      -- 혈액형
    MBTI VARCHAR2(8),       -- MBTI
    BIRTHDAY DATE,       -- 생일
    JOIN_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL,        -- 가입날짜
    POPULARITY NUMBER DEFAULT 0, -- (좋아요받은 수)
    RATING NUMBER DEFAULT 0, -- 유저 평점(리뷰에서 받은 평점의 평균 0점 빼고 계산)
    IS_ADMIN VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(IS_ADMIN IN ('Y', 'N')),      -- 관리자 권한 유무    
    IS_DELETED VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(IS_DELETED IN ('Y', 'N'))      -- 탈퇴 유무    
);


-- 차단 유저 정보
CREATE TABLE BLOCK_USERS( 
    BLOCK_USER_SEQ NUMBER PRIMARY KEY,     -- 유저 차단 SEQ
    USER_ID VARCHAR2(50) NOT NULL,  -- 유저 ID
    BLOCK_ID VARCHAR2(50) NOT NULL,     -- 차단 유저 ID
    BLOCK_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL,    -- 차단 일자 
    BLOCK_REASON VARCHAR2(100),     -- 차단 이유
    UNBLOCK VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(UNBLOCK IN ('Y', 'N'))  -- 차단 해제
);       -- 지역 SEQ


-- 유저 인기도 테이블
CREATE TABLE USER_LIKE( 
    LIKE_UP_SEQ NUMBER PRIMARY KEY,     --  인기도 SEQ
    LIKE_UP_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL,     -- 인기도UP 누른 날짜
    LIKE_UP_USER VARCHAR(50) NOT NULL,      -- UP 눌러준 ID
    LIKE_UP_TARGET VARCHAR(50) NOT NULL   -- UP 눌려진 ID
);

-- 게시글 테이블
CREATE TABLE POST (
    POST_SEQ NUMBER PRIMARY KEY,            -- 글 SEQ(PK)
    POST_TITLE VARCHAR2(200) NOT NULL,     -- 글 제목
    POST_CONTENT VARCHAR2(4000) NOT NULL,  -- 글 내용
    POST_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL, -- 글 작성 시각
    POST_VIEW NUMBER DEFAULT 0 NOT NULL,   -- 조회수
    USER_ID VARCHAR2(50) NOT NULL,    -- 글 작성자 아이디(FK)
    PLACE_SEQ NUMBER DEFAULT 0,                      -- 지역 SEQ(FK)        (매칭글만 필요 이외에는 0)
    BOARD_SEQ NUMBER DEFAULT 0,                      -- 게시판 SEQ(매칭글인지, 리뷰글인지, 커뮤니티글인지 구분) (FK)
    MATCHED VARCHAR2(1) DEFAULT 'N' CHECK(MATCHED IN ('Y', 'N')), -- 매칭완료 여부
    POST_TITLE_DROPBOX VARCHAR2(1) DEFAULT 'N' CHECK(POST_TITLE_DROPBOX IN ('Y', 'N')), -- 드롭박스 사용 여부
    POST_DELETE VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(POST_DELETE IN ('Y', 'N')) -- 글 삭제 여부
);

-- 게시글 첨부 파일 정보 테이블
CREATE TABLE POST_ATTACHMENTS (
    POST_ATTACHMENT_SEQ NUMBER PRIMARY KEY,                   -- 게시글 첨부 파일 정보 SEQ(PK)
    POST_SEQ NUMBER,                                              -- 글 SEQ(FK)
    ATTACHMENT_URL VARCHAR2(3000)                       -- 첨부 파일 URL
);

-- 게시판
CREATE TABLE BOARD( 
    BOARD_SEQ NUMBER PRIMARY KEY,
    BOARD_NAME VARCHAR2(100) NOT NULL UNIQUE, -- 게시판 이름
    BOARD_ADMIN_ONLY VARCHAR2(1) DEFAULT 'N' CHECK(BOARD_ADMIN_ONLY IN ('Y','N')) -- 관리자 전용(Y/N)
);


-- 매칭 신청자 유저 정보
CREATE TABLE MATCHING_USER_INFO (
    MATCHING_USER_INFO_SEQ NUMBER PRIMARY KEY, -- 매칭 신청자 유저 정보 SEQ(PK)
    POST_SEQ NUMBER,                    -- 매칭 SEQ(FK)
    USER_ID VARCHAR(50) NOT NULL,           -- 매칭 신청자 아이디(FK)
    SCORE NUMBER DEFAULT 0 CHECK(SCORE IN (0, 1, 2, 3)), -- 받은 평점 (1~3점만 줄 수 있음 0점은 불가)
    MATCHING_ACCEPT VARCHAR2(1) DEFAULT NULL CHECK(MATCHING_ACCEPT IN ('Y')) -- 매칭 승락 여부
);


-- 댓글
CREATE TABLE COMMENTS( 
    COMMENTS_SEQ NUMBER PRIMARY KEY,                                                     -- 댓글 SEQ 
    POST_SEQ NUMBER,                                                   -- 게시글 SEQ
    COMMENTS_PARENT_SEQ NUMBER,                                              -- 부모댓글 SEQ
    USER_ID VARCHAR2(200),                                             -- 아이디 SEQ
    COMMENTS_DESC VARCHAR2(1000) NOT NULL,                                   -- 댓글 내용
    COMMENTS_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL,                             -- 댓글작성시각
    SECRET_COMMENTS VARCHAR2(1) DEFAULT 'N' CHECK(SECRET_COMMENTS IN('N','Y')),   -- 비밀댓글(Y/N)
    COMMENTS_DELETE VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK(COMMENTS_DELETE IN ('Y', 'N'))  -- 댓글 삭제
);

-- 댓글 좋아요
CREATE TABLE COMMENT_LIKE(
    CL_SEQ NUMBER PRIMARY KEY,                         -- 댓글좋아요 SEQ
    CL_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL, -- 댓글좋아요 누른시간
    COMMENTS_SEQ NUMBER,                              -- 댓글 SEQ
    USER_ID VARCHAR2(200)                       -- 아이디
);

-- 카테고리
CREATE TABLE CATEGORY(
    CATEGORY_SEQ NUMBER PRIMARY KEY,            -- 카테고리(관심사) SEQ
    CATEGORY_NAME VARCHAR2(200) UNIQUE,    -- 카테고리(관심사) 이름
    CT_SEQ NUMBER             -- 카테고리(관심사)분류 SEQ
);

-- 카테고리(관심사)분류
CREATE TABLE CATEGORY_TYPE(
    CT_SEQ NUMBER PRIMARY KEY,           -- 카테고리(관심사)분류 SEQ
    CT_NAME VARCHAR2(200) UNIQUE  -- 카테고리(관심사)분류이름/매칭게시판 이름
);

-- 지역
CREATE TABLE PLACE(
    PLACE_SEQ NUMBER PRIMARY KEY,
    PLACE_NAME VARCHAR2(100) NOT NULL, -- 지역 이름
    PLACE_TYPE_SEQ NUMBER      -- 지역 분류 SEQ
);

-- 지역분류
CREATE TABLE PLACE_TYPE(
    PLACE_TYPE_SEQ NUMBER PRIMARY KEY,  
    PLACE_TYPE_NAME VARCHAR2(100) NOT NULL -- 지역 분류 이름
);

-- 유저 관심사 정보
CREATE TABLE USER_CATEGORY_INFO(
    USER_CATEGORY_SEQ NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(200),
    CATEGORY_SEQ NUMBER
);

-- 게시글 관심사 정보
CREATE TABLE MATCHING_CATEGORY_INFO(
    MATCHING_CATEGORY_SEQ NUMBER PRIMARY KEY,
    POST_SEQ NUMBER,
    CATEGORY_SEQ NUMBER
);

-- 유저채팅방정보 테이블
CREATE TABLE USER_CHATROOM_INFO (
    USER_CHATROOM_INFO_SEQ NUMBER PRIMARY KEY,
    CHATROOM_SEQ NUMBER,
    USER_ID VARCHAR2(50),
    LEAVE VARCHAR2(10) DEFAULT 'N' CHECK (LEAVE IN ('Y', 'N')),
    JOIN_DATE TIMESTAMP DEFAULT SYSDATE,
    JOIN_MESSAGE_SENT VARCHAR2(10) DEFAULT 'N' CHECK (JOIN_MESSAGE_SENT IN ('Y', 'N'))
);

-- 채팅메세지 테이블
CREATE TABLE CHATMESSAGE (
    CHATMESSAGE_SEQ NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(50),
    CHATROOM_SEQ NUMBER,
    MESSAGE VARCHAR2(1000),
    SEND_TIME TIMESTAMP DEFAULT SYSDATE
);

-- 채팅방 테이블
CREATE TABLE CHATROOM (
    CHATROOM_SEQ NUMBER PRIMARY KEY,
    POST_SEQ NUMBER,
    CREATED_TIME TIMESTAMP DEFAULT SYSDATE
);



-- 기본값 생성
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('없음', '없음', '없음', '없', '남', '0', '0');


INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user3', '2', '민수홍', '홍', '남', '10', '1');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user4', '3', '민홍수', '수', '남', '1', '2');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user5', '4', '홍민수', '민', '남', '2', '3');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user6', '5', '수홍민', '박', '남', '3', '4');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user7', '6', '수민홍', '사', '남', '4', '5');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user8', '7', '홍수민', '님', '남', '5', '6');
INSERT INTO USER_INFO(USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, GENDER, PHONE, EMAIL) VALUES('user9', '8', '홍홍민', '을', '남', '6', '7');


INSERT INTO PLACE VALUES(0, '없음', 0);
INSERT INTO PLACE_TYPE VALUES(0, '없음');
INSERT INTO BOARD VALUES(0, '없음', 'Y');
INSERT INTO BOARD VALUES(1, '끼리', 'N');
INSERT INTO BOARD VALUES(2, '리뷰', 'N');

-- FK
ALTER TABLE BLOCK_USERS ADD CONSTRAINT BLOCK_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO (USER_ID);     -- 유저아이디(유저정보, 차단유저정보)
ALTER TABLE BLOCK_USERS ADD CONSTRAINT BLOCK_USER_ID_FK2 FOREIGN KEY(BLOCK_ID) REFERENCES USER_INFO (USER_ID);    -- 유저아이디(유저정보, 차단유저정보)
ALTER TABLE USER_LIKE ADD CONSTRAINT LIKE_USER_ID_FK FOREIGN KEY(LIKE_UP_USER) REFERENCES USER_INFO(USER_ID);   -- 유저아이디(유저정보, 유저 좋아요)
ALTER TABLE USER_LIKE ADD CONSTRAINT LIKE_USER_ID_FK2 FOREIGN KEY(LIKE_UP_TARGET) REFERENCES USER_INFO(USER_ID); -- 유저아이디(유저정보, 유저 좋아요)
ALTER TABLE POST ADD CONSTRAINT POST_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);   -- 유저아이디(유저정보, 게시글)
ALTER TABLE MATCHING_USER_INFO ADD CONSTRAINT MATCHING_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);      -- 유저아이디 (유저정보, 매칭 신청자 유저 정보)
ALTER TABLE COMMENTS ADD CONSTRAINT COMMENTS_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);            -- 유저아이디(유저정보, 댓글)
ALTER TABLE COMMENT_LIKE ADD CONSTRAINT COMMENT_LIKE_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);         -- 유저아이디(유저정보, 댓글 좋아요)
ALTER TABLE USER_CATEGORY_INFO ADD CONSTRAINT CATEGORY_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);         -- 유저아이디(유저정보, 유저 카테고리정보)
ALTER TABLE USER_CHATROOM_INFO ADD CONSTRAINT USER_ID_CHATROOM_INFO_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);
ALTER TABLE CHATMESSAGE ADD CONSTRAINT CHATMESSAGE_USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES USER_INFO(USER_ID);

ALTER TABLE COMMENTS ADD CONSTRAINT COMMENTS_POST_SEQ_FK FOREIGN KEY(POST_SEQ) REFERENCES POST(POST_SEQ);   -- 게시글 SEQ(게시글, 댓글)
ALTER TABLE POST_ATTACHMENTS ADD CONSTRAINT POST_ATTACHMENTS_SEQ_FK FOREIGN KEY(POST_SEQ) REFERENCES POST(POST_SEQ);   -- 게시글 SEQ(게시글, 게시글첨부파일정보)
ALTER TABLE MATCHING_CATEGORY_INFO ADD CONSTRAINT MATCHING_CATEGORY_INFO_SEQ_FK FOREIGN KEY(POST_SEQ) REFERENCES POST(POST_SEQ);   -- 게시글 SEQ(게시글, 매칭글관심사정보)
ALTER TABLE MATCHING_USER_INFO ADD CONSTRAINT MATCHING_USER_INFO_SEQ_FK FOREIGN KEY(POST_SEQ) REFERENCES POST(POST_SEQ);   -- 게시글 SEQ(게시글, 매칭글관심사정보)


ALTER TABLE USER_CATEGORY_INFO ADD CONSTRAINT USER_CATEGORY_SEQ_FK FOREIGN KEY(CATEGORY_SEQ) REFERENCES CATEGORY(CATEGORY_SEQ);   --  카테고리 SEQ(카테고리, 유저관심사정보)
ALTER TABLE MATCHING_CATEGORY_INFO ADD CONSTRAINT MATCHING_CATEGORY_SEQ_FK FOREIGN KEY(CATEGORY_SEQ) REFERENCES CATEGORY(CATEGORY_SEQ);   --  카테고리 SEQ(카테고리, 게시글카테고리정보)

ALTER TABLE CATEGORY ADD CONSTRAINT CATEGORY_CT_SEQ_FK FOREIGN KEY(CT_SEQ) REFERENCES CATEGORY_TYPE(CT_SEQ);   --  카테고리분류 SEQ(카테고리분류, 카테고리)

ALTER TABLE POST ADD CONSTRAINT POST_PLACE_SEQ_FK FOREIGN KEY(PLACE_SEQ) REFERENCES PLACE(PLACE_SEQ); -- 지역 SEQ(지역, 게시글)
ALTER TABLE USER_INFO ADD CONSTRAINT USER_PLACE_TYPE_SEQ_FK FOREIGN KEY(PLACE_TYPE_SEQ) REFERENCES PLACE_TYPE(PLACE_TYPE_SEQ); -- 지역 SEQ(지역, 유저정보)

ALTER TABLE PLACE ADD CONSTRAINT PLACE_PT_SEQ_FK FOREIGN KEY(PLACE_TYPE_SEQ) REFERENCES PLACE_TYPE(PLACE_TYPE_SEQ); -- 지역분류 SEQ(지역분류, 지역)

ALTER TABLE POST ADD CONSTRAINT POST_BOARD_SEQ_FK FOREIGN KEY(BOARD_SEQ) REFERENCES BOARD(BOARD_SEQ);  -- 게시판 SEQ(게시판, 게시글)

ALTER TABLE COMMENT_LIKE ADD CONSTRAINT COMMENT_LIKE_COMMENTS_SEQ_FK FOREIGN KEY(COMMENTS_SEQ) REFERENCES COMMENTS(COMMENTS_SEQ);  -- 댓글 SEQ(댓글, 댓글좋아요)


-- 채팅관련 FK
ALTER TABLE USER_CHATROOM_INFO ADD CONSTRAINT USER_CHATROOM_INFO_FK FOREIGN KEY(CHATROOM_SEQ) REFERENCES CHATROOM (CHATROOM_SEQ);
ALTER TABLE CHATMESSAGE ADD CONSTRAINT CHATMESSAGE_ROOM_FK FOREIGN KEY(CHATROOM_SEQ) REFERENCES CHATROOM (CHATROOM_SEQ);
ALTER TABLE CHATROOM ADD CONSTRAINT CHATROOM_POST_FK FOREIGN KEY(POST_SEQ) REFERENCES POST (POST_SEQ);

-- 시퀀스 생성
CREATE SEQUENCE SEQ_BLOCK_USER; -- 유저차단 SEQ
CREATE SEQUENCE SEQ_BOARD; -- 게시판 SEQUENCE
CREATE SEQUENCE SEQ_CATEGORY;             -- 카테고리 SEQ
CREATE SEQUENCE SEQ_CATEGORY_TYPE;         -- 카테고리(관심사)분류 SEQ
CREATE SEQUENCE SEQ_COMMENT_LIKE;         -- 댓글 좋아요 SEQ
CREATE SEQUENCE SEQ_COMMENTS;             -- 댓글 SEQ
CREATE SEQUENCE SEQ_MATCHING_USER_INFO;             -- 매칭유저정보 SEQ
CREATE SEQUENCE SEQ_PLACE;      -- 유저 정보 테이블
CREATE SEQUENCE SEQ_PLACE_TYPE;             -- 지역분류 SEQ
CREATE SEQUENCE SEQ_POST; -- 게시글 SEQUENCE
CREATE SEQUENCE SEQ_POST_ATTACHMENT; -- 게시글 첨부 파일 정보 SEQUENCE
CREATE SEQUENCE SEQ_USER_LIKE; -- 유저 좋아요 SEQ
CREATE SEQUENCE SEQ_USER_CATEGORY_INFO; -- 유저 관심사 정보 SEQ
CREATE SEQUENCE SEQ_MATCHING_CATEGORY_INFO; -- 매칭글 관심사 정보 SEQ
CREATE SEQUENCE SEQ_USER_CHATROOM_INFO;
CREATE SEQUENCE SEQ_CHATMESSAGE;
CREATE SEQUENCE SEQ_CHATROOM;

-- 카테고리(관심사) 타입 생성
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '문화 · 예술');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '운동 · 액티비티');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '생활 · 쇼핑');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '게임 · 놀이');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '온라인게임');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '음식');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '공부');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '애완동물');
INSERT INTO CATEGORY_TYPE VALUES(SEQ_CATEGORY_TYPE.NEXTVAL, '차 · 오토바이');

-- 카테고리(관심사) 생성
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '영화감상', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '애니메이션감상', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '공연관람', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '뮤지컬관람', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '전시회관람', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '독서', 1);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '스포츠관람', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '축구 · 풋살', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '농구', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '야구', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '배드민턴', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '테니스', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '수영', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '볼링', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '탁구', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '골프', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '등산', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '클라이밍', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '러닝', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '사이클', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '헬스', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '크로스핏', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '여행 · 관광', 2);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '산책', 3);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '팝업스토어방문', 3);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '공동구매', 3);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '쇼핑', 3);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '동네친구', 3);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '보드게임', 4);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '카드게임', 4);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '방탈출카페', 4);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '테마파크 · 놀이공원', 4);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '리그오브레전드', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '발로란트', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '오버워치', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '피파온라인', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '배틀그라운드', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '서든어택', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '메이플스토리', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '던전앤파이터', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '기타 PC · 콘솔 게임', 5);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '맛집탐방', 6);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '겸상', 6);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '스터디', 7);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '학원같이다니기', 7);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '반려동물 동반 산책', 8);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '분양', 8);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '펫페어', 8);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '라이딩', 9);
INSERT INTO CATEGORY VALUES(SEQ_CATEGORY.NEXTVAL, '모터쇼', 9);


-- 지역 분류
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '서울특별시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '부산광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '대구광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '인천광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '광주광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '대전광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '울산광역시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '세종특별자치시');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '경기도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '충청북도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '충청남도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '전라북도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '전라남도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '경상북도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '경상남도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '제주특별자치도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '강원특별자치도');
INSERT INTO PLACE_TYPE VALUES(SEQ_PLACE_TYPE.NEXTVAL, '기타');


-- 지역

-- 서울특별시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '종로구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '용산구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성동구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '광진구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동대문구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중랑구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성북구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '도봉구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '노원구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '은평구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서대문구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '마포구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양천구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강서구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '구로구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '금천구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영등포', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동작구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '관악구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서초구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강남구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '송파구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '종로구', 1);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강동구', 1);

-- 부산광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '용산구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영도구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '부산진구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동래구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '북구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '해운대구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '사하구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '금정구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강서구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '연제구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수영구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '사상구', 2);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '기장군', 2);

-- 대구광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '북구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수성구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '달서구', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '달성군', 3);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '군위군', 3);

-- 인천광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '미추홀구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '연수구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남동구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '부평구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '계양구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서구', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강화군', 4);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '옹진군', 4);

-- 광주광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 5);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서구', 5);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남구', 5);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '북구', 5);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '광산구', 5);

-- 대전광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 6);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 6);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서구', 6);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '유성구', 6);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '대덕구', 6);

-- 울산광역시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '중구', 7);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남구', 7);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동구', 7);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '북구', 7);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '울주군', 7);

-- 세종특별 자치시
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '세종시', 8);    //  <-- 세종시 9개 고정 선택안되게하기

-- 경기도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수원시 장안구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수원시 권선구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수원시 팔달구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성남시 수정구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성남시 중원구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성남시 분당구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '의정부시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안양시 만안구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안양시 동안구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '부천시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '광명시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '평택시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동두천시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고양시 덕양구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고양시 일산동구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '과천시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '구리시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남양주시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '오산시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '시흥시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '군포시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '의왕시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '하남시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '파주시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '이천시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안성시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '김포시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고양시 일산서구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '연천군', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '가평군', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양평군', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '화성시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '광주시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안산시 상록구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안산시 단원구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양주시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '포천시', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '수원시 영통구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '용인시 처인구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '용인시 기흥구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '용인시 수지구', 9);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '여주시', 9);

-- 충청북도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '충주시', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '제천시', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '보은군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '옥천군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영동군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '진천군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '괴산군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '음성군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '단양군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '증평군', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청주시 상당구', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청주시 서원구', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청주시 흥덕구', 10);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청주시 청원구', 10);
-- 충청남도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '공주시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '보령시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '아산시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서산시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '논산시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '금산군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '부여군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서천군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청양군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '홍성군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '예산군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '태안군', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '계룡시', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '천안시 동남구', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '천안시 서북구', 11);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '당진시', 11);

-- 전라북도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '전주시 완산구', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '전주시 덕진구', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '군산시', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '익산시', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '정읍시', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남원시', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '김제시', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '완주군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '진안군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '무주군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '장수군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '임실군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '순창군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고창군', 12);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '부안군', 12);
--전라남도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '목포시', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '여수시', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '순천시', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '나주시', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '광양시', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '담양군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '곡성군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '구례군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고흥군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '보성군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '화순군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '장흥군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강진군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '해남군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영암군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '무안군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '함평군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영광군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '장성군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '완도군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '진도군', 13);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '신안군', 13);

--경상북도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '포항시 남구', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '포항시 북구', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '경주시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '김천시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '안동시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '구미시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영주시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영천시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '상주시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '문경시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '경산시', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '의성군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청송군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영양군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영덕군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '청도군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고령군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '성주군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '칠곡군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '예천군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '봉화군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '울진군', 14);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '울릉군', 14);

-- 경상남도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '진주시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '통영시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '사천시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '김해시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '밀양시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '거제시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양산시', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '의령군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '함안군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창녕군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고성군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '남해군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '하동군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '산청군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '함양군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '거창군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '합천군', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창원시 의창구', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창원시 성산구', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창원시 마산합포구', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창원시 마산회원구', 15);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '창원시 진해구', 15);

--제주특별자치도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '제주시', 16);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '서귀포시', 16);

--강원특별자치도
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '춘천시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '원주시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '강릉시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '동해시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '태백시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '속초시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '삼척시', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '홍청군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '횡성군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '영월군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '평창군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '정선군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '철원군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '화천군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양구군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '인제군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '고성군', 17);
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '양양군', 17);

--기타
INSERT INTO PLACE VALUES(SEQ_PLACE.NEXTVAL, '온라인', 18);

SELECT * FROM COMMENTS;

INSERT INTO POST VALUES(SEQ_POST.NEXTVAL, '으앙', '헥헥', DEFAULT, DEFAULT, 'user3', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);
INSERT INTO CHATROOM VALUES(SEQ_CHATROOM.NEXTVAL, '1', DEFAULT);

--INSERT INTO USER_CHATROOM_INFO VALUES(SEQ_USER_CHATROOM_INFO.NEXTVAL, 14, 'rlaalstn', DEFAULT, DEFAULT, DEFAULT);
--INSERT INTO USER_CHATROOM_INFO VALUES(SEQ_USER_CHATROOM_INFO.NEXTVAL, 15, 'rlaalstn', DEFAULT, DEFAULT, DEFAULT);
--INSERT INTO USER_CHATROOM_INFO VALUES(SEQ_USER_CHATROOM_INFO.NEXTVAL, 16, 'rlaalstn', DEFAULT, DEFAULT, DEFAULT);
--INSERT INTO USER_CHATROOM_INFO VALUES(SEQ_USER_CHATROOM_INFO.NEXTVAL, 2, 'sumin', DEFAULT, DEFAULT);
--UPDATE USER_CHATROOM_INFO SET LEAVE = 'N' WHERE USER_ID = 'rlaalstn'; 
--UPDATE USER_CHATROOM_INFO SET JOIN_MESSAGE_SENT = 'N' WHERE USER_ID = 'rlaalstn'; 


COMMIT;



select * from matching_user_info;


select * from chatroom;

select * from post;

